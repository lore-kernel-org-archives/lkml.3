Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab3BMQN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:13:57 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44697 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403Ab3BMQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:13:54 -0500
Date: Wed, 13 Feb 2013 17:13:53 +0100
From: Andreas Mohr <andi@lisas.de>
To: Colin Guthrie <gmane@colin.guthr.ie>
Cc: initramfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [nailed] USB boot failure: USB: EHCI: make ehci-pci
 a separate driver
Message-ID: <20130213161353.GA17177@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B7009.6030501@colin.guthr.ie>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[not sure about CCs - I readded both initramfs-tools and lkml]

> I think you actually want both: ehci-pci and ehci-platform (tho' perhaps
> the module deps mean only the -pci one is needed)

Err, yeah, that's probably more precise.

> Either way I already posted a patch about this a while back:

> See: "[PATCH 6/6] kernel-modules: Add ehci support for kernel 3.8+"

OK, I've seen it, but:
which file does it touch?? That's a complete mystery to me
(the initramfs-tools git checkout here does not contain that path).

> (admittedly perhaps that should have been 3.7 rather than 3.8)!

Hmm, the patch was introduced in early moments from 3.7 prior to
3.8-rc1. Thus one could say that the non-covered window is only
a part of the small 3.8-rc1 step which is used by devel people only.
OTOH to retain the very important development property
of properly working regression bisects over all versions
(of regressions *other* than this USB boot effect, that is),
even that smallish window ought to be fully covered.
If it thus is decided to be a sizeable versioning issue,
then it really should be downgraded to 3.7 very soon,
in order to prevent a support window coverage issue.

Thanks,

Andreas Mohr
