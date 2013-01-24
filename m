Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187Ab3AXVvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:51:10 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:44344 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3AXVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:50:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOPvK5S92ESU12yN5U=8fjSDFtDMrjJAmqxkqqTrzFzVCA@mail.gmail.com>
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
	<CAKocOONcM4HK1ZtUJb7C1xVCEWcz_pG2UZ0hzxGpxSmBSYa1Ww@mail.gmail.com>
	<CAKocOOPvK5S92ESU12yN5U=8fjSDFtDMrjJAmqxkqqTrzFzVCA@mail.gmail.com>
Date: Thu, 24 Jan 2013 13:50:58 -0800
X-Google-Sender-Auth: k5mU6-w2m2WfZdeabkuOpnLRcwQ
Message-ID: <CAE9FiQVvO+mgZxKmA4aGS0ujngux97kK7F0JkA4oYVhVEi_bGw@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
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

On Thu, Jan 24, 2013 at 11:22 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>
>> I still have the AMD system I tested earlier versions of this work. I
>> started compiles with these patches on 3.7 and will let you know the
>> status.
>
> Tested 3.8-rc4 with the patches on AMD system with IOMMU on. Looks
> good. I can't test low memory paths on this system very easily without
> mucking with the code and force it treat it as low memory. So I just
> tested the normal path. My main goal was to make sure AMD iommu driver
> can still enable switolb and it does.

good.

>
> If you would like to me test the error cases, please let me know.

please check
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot

and boot your test setups with memmap=4095$1M

Thanks

Yinghai
