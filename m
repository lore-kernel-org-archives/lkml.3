Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3DRJIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:08:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32780 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab3DRJIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:08:07 -0400
Date: Thu, 18 Apr 2013 11:08:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind <aravind.gopalakrishnan@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH V4] edac: Handle EDAC ECC errors for Family 16h
Message-ID: <20130418090800.GA21719@pd.tnic>
References: <1366228633-3159-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130417212022.GA9181@pd.tnic>
 <516F41FF.8000202@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516F41FF.8000202@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 07:44:47PM -0500, Aravind wrote:
> For some reason, this hunk does not apply cleanly..
> I tried this: (moving the line)
> 
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
> 	{}

I swapped that in your patch because wanted to have those sorted. We're
probably using different trees though..

> and this seems to work..
> Otherwise, I tested the patch and it works.

Ok, good.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
