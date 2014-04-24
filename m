Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaDXK3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:29:53 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:41075 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaDXK3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <5358E4B9.1050308@nod.at>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-14-git-send-email-lftan@altera.com>
	<CAFLxGvyPCwo-d92QK9qAR5=gmRS4p24tYs9PiOApBGfrKdxJ5Q@mail.gmail.com>
	<CAFiDJ5-q5hzR+1BDCmCzwqbuVZOUdjX_-omR4u3rnC8xqdQZLA@mail.gmail.com>
	<CAFiDJ59g0E+hoREriydqk2uBsDvchPMSQi6NCgnwOd64OGLJ0w@mail.gmail.com>
	<5358E4B9.1050308@nod.at>
Date: Thu, 24 Apr 2014 18:29:46 +0800
X-Google-Sender-Auth: USL6jmxs35_UgXwwzSXB7WdgiXE
Message-ID: <CAFiDJ5_pbcQo7VPj6J9UVhxGQtGn7hX19vkybL3DvM73v8Dc-w@mail.gmail.com>
Subject: Re: [PATCH 17/28] nios2: Signal handling support
From: Ley Foon Tan <lftan@altera.com>
To: Richard Weinberger <richard@nod.at>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 6:17 PM, Richard Weinberger <richard@nod.at> wrote:

>>> Okay.
>>>
>> I just noticed that sigsp() have struct ksignal argument. We can use
>> sigsp() for nios2 because it doesn't have struct ksignal.
>>
>> unsigned long sigsp(unsigned long sp, struct ksignal *ksig);
>
> Did you at look at the struct ksignal definition and the clean series I've
> pointed you to?
>

Not yet, this is the full set of patches? I only see partial..
https://lkml.org/lkml/2014/3/2/198
