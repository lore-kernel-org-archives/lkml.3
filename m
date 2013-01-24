Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3AXPjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:39:37 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53440 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3AXPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:39:34 -0500
Date: Thu, 24 Jan 2013 10:39:25 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130124153924.GA5943@konrad-lan.dumpdata.com>
References: <20130109132409.GB18395@phenom.dumpdata.com>
 <CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
 <87d2xeul5v.fsf@xmission.com>
 <CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
 <CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
 <20130111163548.GB25620@phenom.dumpdata.com>
 <CAE9FiQVts6aTaRFM3aKWj46RCRiheM5gS55h=LVveaGXk_kR8g@mail.gmail.com>
 <CAE9FiQVTfTisOrrQhv0vmsgA8Asaj5EUE5s93OFyTHfA+dWdfQ@mail.gmail.com>
 <CAE9FiQWU6mnWxnzDtaR51H7GTbYmKgb0zy6xRCGYO4+oyc82Gg@mail.gmail.com>
 <20130118155535.GJ9973@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118155535.GJ9973@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:55:35AM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 14, 2013 at 10:19:22PM -0800, Yinghai Lu wrote:
> > On Fri, Jan 11, 2013 at 9:49 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > > On Fri, Jan 11, 2013 at 8:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > >>>
> > >>> I need to check this patch out and then also test-run them on IA64, AMD-VI, Calgary-X
> > >>> GART and Intel VT-d to make a sanity test.
> > >>
> > >> that will be great, and please check attached two patches, or you want
> > >> to me update
> > >> for-x86-boot branch and you test that instead?
> > >>
> > >> but if you want to check memmap=4095M$1M, then will need to test on
> > >> newer branch.
> > >
> > >
> > > I updated the for-x86-boot branch.
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> > > for-x86-boot
> > >
> > 
> > Konrad,
> > 
> > Did you get chance to test that branch on your setups?
> 
> I tested it on the IA64 box - it worked without any hiccups. Going to
> try the Calgary-X and the rest of the machines over the weekend.

Worked without issues on AMD GART, AMD Vi, Intel VT-d, and on boxes
without any IOMMU.

I am having trouble getting my Calgary-X box to power on, so that
testing is taking a bit longer.

> > 
> > Thanks
> > 
> > Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
