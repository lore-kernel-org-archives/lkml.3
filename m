Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaB0QbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:31:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54901 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaB0QbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:31:16 -0500
Date: Thu, 27 Feb 2014 17:31:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dougthompson@xmission.com, bhelgaas@google.com, JBeulich@suse.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
        Arindam.Nath@amd.com
Subject: Re: [PATCH] amd64_edac: Add support for newer F16h models
Message-ID: <20140227163108.GH18191@pd.tnic>
References: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140221142749.GC11531@pd.tnic>
 <5307BF6F.8040303@amd.com>
 <20140224140931.GA16457@pd.tnic>
 <530F6643.5090009@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <530F6643.5090009@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:22:27AM -0600, Aravind Gopalakrishnan wrote:
> Ok, here's more info: we will need to add support in k10temp for this
> model; and support is not required in fam15h_power as register bits
> used by the driver code are unavailable for OS. But F{3,4} usage is
> split: k10temp uses F3 device ID and fam15h_power uses F4 device ID.
>
> Not sure if you want to split these definitions between amd_nb.h and
> pci_ids.h or just let it be.

Yeah, let's let it be. Thanks for getting the info - I'll ack the
original submission.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
