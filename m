Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaIETUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaIETUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:20:40 -0400
Message-ID: <540A0CF9.6060606@redhat.com>
Date: Fri, 05 Sep 2014 21:20:25 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Anders Darander <anders@chargestorm.se>,
        Matt Fleming <matt@console-pimps.org>,
        =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>	<20140904100137.GK3001@console-pimps.org>	<5408D299.5000300@zytor.com>	<20140904212925.GL3001@console-pimps.org>	<CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>	<20140905054749.GA4498@ad.chargestorm.se>	<54095A5B.4030606@redhat.com> <CAE9FiQV7XLwKsYWprmKAkZGGyuFeK=o_b1_ABMbEGVZzZxtp2w@mail.gmail.com>
In-Reply-To: <CAE9FiQV7XLwKsYWprmKAkZGGyuFeK=o_b1_ABMbEGVZzZxtp2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 19:03, Yinghai Lu wrote:
> On Thu, Sep 4, 2014 at 11:38 PM, Laszlo Ersek <lersek@redhat.com> wrote:
>> On 09/05/14 07:47, Anders Darander wrote:
>> In other words, the rounding up of the kernel will be undone in a
>> "somewhat higher level" driver in the firmware, and the request size
>> that reaches DiskIo (the "lowel level driver") remains the same.
> 
> Thanks for explanation.
> 
> Is there any way to check if EFI firmware have your fix from some calling?

I can't think of any, alas.

It might make sense to contact Mantas's and Anders's UEFI vendors; after
all a reliable reproducer is available.

Thanks,
Laszlo

