Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaFPNCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:02:04 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:36764 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaFPNCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZscH2Re5jytGeCcBE2jZO+xngZ-r_P5NuR=KsoB+QyaDA@mail.gmail.com>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
	<CALAqxLUoc45535haDAuoNXSSmNqTZF1uiOMF8PyaDp_A+_dnWA@mail.gmail.com>
	<CAPDyKFp022H9xryjVvGNEw_Xiyb0zccb8tjawBT1y0+JB=wZ9g@mail.gmail.com>
	<CAAJw_ZscH2Re5jytGeCcBE2jZO+xngZ-r_P5NuR=KsoB+QyaDA@mail.gmail.com>
Date: Mon, 16 Jun 2014 15:02:01 +0200
Message-ID: <CAPDyKFqA4ZgS1eUpiDWv2WTigFoMFsEDT4T5ci6asWuNiOLF5Q@mail.gmail.com>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, Chris Ball <chris@printf.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2014 09:22, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Fri, Jun 13, 2014 at 8:28 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 13 June 2014 01:51, John Stultz <john.stultz@linaro.org> wrote:
>>> On Wed, Jun 11, 2014 at 10:35 PM, John Stultz john.stultz@linaro.org> wrote:
>
>> I have quickly implemented my proposal 1). I am testing them on real
>> HW now, will post the patches as soon as I can and keep you on cc.
>>
>> I would also really appreciate if you could help out giving them a
>> quick try for your QEMU environment.
>
> Please cc me the patch. I'm seeing my host's reiserfs corrupted with
> qemu all over the places in linux-3.15.0 (linux-3.16-rc1). Pretty sure
> it's qemu as it doesn't seem to happen if I don't run qemu.
>
> Thanks,
> Jeff

Hi Jeff,

I posted them prior I noticed this, sorry. There are three patches for
the mmci driver, just search for "mmci".

Kind regards
Uffe
