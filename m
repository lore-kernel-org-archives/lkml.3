Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbaELBDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:03:15 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:33117
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaELBDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:03:13 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=EBe6uRzgOt0A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=zd2uoN0lAAAA:8
 a=Z4Rwk6OoAAAA:8 a=P6JkxrBpAAAA:8 a=ObclLZvKEjuZWZCWu1QA:9 a=QEXdDO2ut3YA:10
 a=wu_e27o_rKQA:10 a=jbrJJM5MRmoA:10
Date: Mon, 12 May 2014 02:03:10 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org,
        zarniwhoop@ntlworld.com
Subject: Re: More breakage on HD7480D [ Aruba ]
Message-ID: <20140512010310.GA4370@milliways>
References: <20140512003405.GA3386@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140512003405.GA3386@milliways>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 01:34:06AM +0100, Ken Moffat wrote:

 /me swears at myself for failing to copy to lkml.

> Hi Christian, Alex -
> 
>  my A4 Trinity (Radeon HD7480D) was working fine by -rc3.  But now
> that I've tested it in -rc5 it is again broken (the screen goes
> blank when KMS starts).  Bisection blames:
> 
> 3b333c55485fef0089ae7398906599d000df195e is the first bad commit
> commit 3b333c55485fef0089ae7398906599d000df195e
> Author: Christian König <christian.koenig@amd.com>
> Date:   Thu Apr 24 18:39:59 2014 +0200
> 
>     drm/radeon: avoid high jitter with small frac divs
>     
>     Signed-off-by: Christian König <christian.koenig@amd.com>
> 
>  Reverting that from current HEAD [
> 
> commit 7e338c9991ecee9c2ac7a4cee2c2e11ecb563d02
> Merge: 9cf22e80df77 aa07c713ecfc
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun May 11 18:06:13 2014 +0900
> 
>     Merge branch 'for-3.15' of git://linux-nfs.org/~bfields/linux
>     
>     Pull nfsd fixes from Bruce Fields.
> 
> ]
> makes it again boot.
> 
>  Note to Alex - 3.15 has been an "interesting" cycle - you fixed my
> earlier problem, despite my non-response, and thanks again for that.
> After that, my other radeon broke after -rc2 (I retested it after
> rc4 and found that although rc4 was broken, HEAD was fixed, so
> thanks also for that.  Then I retested this one for -rc5.  It seems
> that my boxes always break when I don't have time to test new
> releases :-(
> 
> ĸen
> -- 
> das eine Mal als Tragödie, dieses Mal als Farce

-- 
das eine Mal als Tragödie, dieses Mal als Farce
