Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBXOJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:09:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55379 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaBXOJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:09:34 -0500
Date: Mon, 24 Feb 2014 15:09:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dougthompson@xmission.com, bhelgaas@google.com, JBeulich@suse.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
        Arindam.Nath@amd.com
Subject: Re: [PATCH] amd64_edac: Add support for newer F16h models
Message-ID: <20140224140931.GA16457@pd.tnic>
References: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140221142749.GC11531@pd.tnic>
 <5307BF6F.8040303@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5307BF6F.8040303@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 03:04:47PM -0600, Aravind Gopalakrishnan wrote:
> F{3,4} are used by hwmon/k10temp.c and hwmon/fam15h_power.c and they
> will need definitions to be places here in pci_ids.h But I'm not sure
> if the hwmon drivers need to carry support for this model yet (will
> verify that)
>
> If not, I'll remove them and resend.

Yes, please check that and let me know.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
