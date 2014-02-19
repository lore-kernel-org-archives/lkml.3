Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaBSPB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:01:29 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:53097 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaBSPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:01:28 -0500
Date: Wed, 19 Feb 2014 15:01:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140219150121.GG10504@lee--X1>
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
 <1392641818-23419-3-git-send-email-lee.jones@linaro.org>
 <20140218233645.GP31892@mtj.dyndns.org>
 <20140219083025.GB10504@lee--X1>
 <20140219140458.GA10134@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140219140458.GA10134@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can I do this as a subsequent patch though? The current patch fits
> > neatly onto our internal stable kernel (currently v3.10). The added
> > work will require back-porting Hans' patch-set, which has not yet
> > reached Mainline.
> 
> Hmm.... I'll apply Hans' patchset pretty soon and we still have some
> time in this devel cycle so I'd much prefer applying the final patch.

I think that's a pretty unfair ask. I could understand if the
patch(es) didn't apply, or were hindered by the new API change, but I
do not believe that is the case?

FWIW, I have tried to apply the patches Hans send me, but they don't
seem to apply cleanly.

Base is v3.14-rc1:

Applying: ahci-platform: Add support for devices with more then 1 clock
fatal: sha1 information is lacking or useless (drivers/ata/ahci_platform.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ahci-platform: Add support for devices with more then 1 clock
The copy of the patch that failed is found in:
   .git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Any ideas?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
