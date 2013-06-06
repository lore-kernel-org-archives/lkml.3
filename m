Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3FFKm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:42:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38145 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141Ab3FFKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:42:27 -0400
Date: Thu, 6 Jun 2013 11:42:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606104224.GH30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370177770-26661-4-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Jun, at 02:56:09PM, Borislav Petkov wrote:
> +
> +static int __init parse_efi_cmdline(char *str)
> +{
> +	if (*str == '=')
> +		str++;
> +	if (!strncmp(str, "1:1_map", 7))
> +		efi_config |= EFI_CFG_MAP11;
> +
> +	return 0;
> +}
> +early_param("efi", parse_efi_cmdline);

This is fine for testing, but I genuinely think that this should be on
by default once these patches are final.

-- 
Matt Fleming, Intel Open Source Technology Center
