Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3JKPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:48:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56633 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab3JKPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:48:06 -0400
Date: Fri, 11 Oct 2013 17:47:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
Message-ID: <20131011154759.GJ5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
 <20131011090630.GB5925@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131011090630.GB5925@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 11:06:30AM +0200, Borislav Petkov wrote:
> > -	printk("%s""APEI generic hardware error status\n", pfx);
> > +	printk("%s""Generic Hardware Error Status\n", pfx);
> 
> Btw, what's the story with printk not using KERN_x levels in this file?
> Why are we falling back to default printk levels for all printks here
> and shouldn't we rather prioritize them by urgency into, say, KERN_ERR,
> KERN_INFO, etc?

Ignore that - checkpatch complained about it but I kinda missed that
we're handing down the prefix.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
