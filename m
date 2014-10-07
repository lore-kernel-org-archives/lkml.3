Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaJGJTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:19:54 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53131 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaJGJTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:19:41 -0400
MIME-Version: 1.0
In-Reply-To: <20141007091417.GM25331@lee--X1>
References: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
	<1412086542-1662-2-git-send-email-pramod.gurav@smartplayin.com>
	<CACRpkdZVyxN+W_8s3Hvij0wu=bE-tyAFhJPVKumRvDkpUDuncA@mail.gmail.com>
	<20141007091417.GM25331@lee--X1>
Date: Tue, 7 Oct 2014 11:19:40 +0200
Message-ID: <CACRpkdayTNQNUDw_eZ9brDBAbd-iSLumJrQrrVnABt=C92kUOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: remove use of gpiochip_remove() retval
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 11:14 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 01 Oct 2014, Linus Walleij wrote:
>
>> On Tue, Sep 30, 2014 at 4:15 PM, Pramod Gurav
>> <pramod.gurav@smartplayin.com> wrote:
>>
>> > Get rid of using return value from gpiochip_remove() as it returns
>> > void.
>> >
>> > Cc: Linus Walleij <linus.walleij@linaro.org>
>> > Cc: Alexandre Courbot <gnurou@gmail.com>
>> > Cc: Samuel Ortiz <sameo@linux.intel.com>
>> > CC: Lee Jones <lee.jones@linaro.org>
>> > Cc: linux-gpio@vger.kernel.org
>> >
>> > Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>>
>> Already fixed in the GPIO tree.
>
> What does that mean?  That it doesn't need fixing here?

No. I think you already ACKed the patch fixing it in the GPIO
tree...

There has been some misunderstanding and duplicate patches
fixing already fixed problems are flying around.

Yours,
Linus Walleij
