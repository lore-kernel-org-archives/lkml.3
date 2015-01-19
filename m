Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbbASPTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:19:34 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50702 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbASPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:19:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, Joerg Roedel <jroedel@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Matt Wagantall <mattw@codeaurora.org>, Robert Elliott <elliott@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: Re: [PATCH v10] iopoll: Introduce memory-mapped IO polling macros
Date: Mon, 19 Jan 2015 16:19:18 +0100
Message-ID: <3657890.a3eGsv4NQj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150119144028.GA2373@arm.com>
References: <1418687243-16395-1-git-send-email-mitchelh@codeaurora.org> <20150119124348.GA2806@suse.de> <20150119144028.GA2373@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:mr5CSKyuQAS0ZqYt/2DmTqq/pj8hXmrg4GqTFe+A7D3PfydAFts
 WgdPrgurCDwhKfsDOdt5bCHpxi6jwacNU/tiWdlMxUID1bjD8Jz+cP5ZMeA5GLD/UqA0rya
 Jh866tUpONP1dWiy/ZCoq0NzsvqF6i2Ololzqy4txZ79izUMIktifV8vWUGqqcWIEsbUcbs
 VBFRnQAVv7TrM2cYgSkzg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 14:40:28 Will Deacon wrote:
> On Mon, Jan 19, 2015 at 12:43:48PM +0000, Joerg Roedel wrote:
> > On Thu, Jan 15, 2015 at 10:25:11AM +0000, Will Deacon wrote:
> > > If you get an Ack from any of Arnd/Joerg/akpm then I'm happy to take it via
> > > the arm-smmu pull (along with the patch making use of it).
> > > 
> > > Joerg, would you be ok with that?
> > 
> > I am ok with that, but like to have another Ack for it.
> 
> That's fair enough.
> 
> Arnd, could you take another look at this patch please? You had some
> comments in the past.

No further objections from my side. I don't think it's really needed,
but it seems harmless, so

Acked-by: Arnd Bergmann <arnd@arndb.de>
