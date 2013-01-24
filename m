Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3AXQvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:51:09 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51244 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3AXQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:51:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130124153924.GA5943@konrad-lan.dumpdata.com>
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
	<20130124153924.GA5943@konrad-lan.dumpdata.com>
Date: Thu, 24 Jan 2013 09:51:02 -0700
Message-ID: <CAKocOONcM4HK1ZtUJb7C1xVCEWcz_pG2UZ0hzxGpxSmBSYa1Ww@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Shuah Khan <shuahkhan@gmail.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 8:39 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Fri, Jan 18, 2013 at 10:55:35AM -0500, Konrad Rzeszutek Wilk wrote:
>> On Mon, Jan 14, 2013 at 10:19:22PM -0800, Yinghai Lu wrote:
>> > On Fri, Jan 11, 2013 at 9:49 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > > On Fri, Jan 11, 2013 at 8:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > >>>
>> > >>> I need to check this patch out and then also test-run them on IA64, AMD-VI, Calgary-X
>> > >>> GART and Intel VT-d to make a sanity test.
>> > >>
>> > >> that will be great, and please check attached two patches, or you want
>> > >> to me update
>> > >> for-x86-boot branch and you test that instead?
>> > >>
>> > >> but if you want to check memmap=4095M$1M, then will need to test on
>> > >> newer branch.
>> > >
>> > >
>> > > I updated the for-x86-boot branch.
>> > >
>> > > git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> > > for-x86-boot
>> > >
>> >
>> > Konrad,
>> >
>> > Did you get chance to test that branch on your setups?
>>
>> I tested it on the IA64 box - it worked without any hiccups. Going to
>> try the Calgary-X and the rest of the machines over the weekend.
>
> Worked without issues on AMD GART, AMD Vi, Intel VT-d, and on boxes
> without any IOMMU.
>
> I am having trouble getting my Calgary-X box to power on, so that
> testing is taking a bit longer.
>

I still have the AMD system I tested earlier versions of this work. I
started compiles with these patches on 3.7 and will let you know the
status.

-- Shuah
