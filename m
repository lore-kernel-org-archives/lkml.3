Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3AKRtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:49:46 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:62175 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3AKRtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:49:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVts6aTaRFM3aKWj46RCRiheM5gS55h=LVveaGXk_kR8g@mail.gmail.com>
References: <CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
	<87txqruq8p.fsf@xmission.com>
	<CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
	<CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
	<20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<87d2xeul5v.fsf@xmission.com>
	<CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
	<CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
	<20130111163548.GB25620@phenom.dumpdata.com>
	<CAE9FiQVts6aTaRFM3aKWj46RCRiheM5gS55h=LVveaGXk_kR8g@mail.gmail.com>
Date: Fri, 11 Jan 2013 09:49:43 -0800
X-Google-Sender-Auth: 1yuNVJLC6z1_2m6wMwuC0kvpsMg
Message-ID: <CAE9FiQVTfTisOrrQhv0vmsgA8Asaj5EUE5s93OFyTHfA+dWdfQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 8:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> I need to check this patch out and then also test-run them on IA64, AMD-VI, Calgary-X
>> GART and Intel VT-d to make a sanity test.
>
> that will be great, and please check attached two patches, or you want
> to me update
> for-x86-boot branch and you test that instead?
>
> but if you want to check memmap=4095M$1M, then will need to test on
> newer branch.


I updated the for-x86-boot branch.

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot

Thanks

Yinghai
