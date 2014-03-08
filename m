Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaCHU14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 15:27:56 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:53308 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaCHU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 15:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <1394308828.431.5.camel@x220>
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
	<1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
	<CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
	<1394308828.431.5.camel@x220>
Date: Sun, 9 Mar 2014 04:27:54 +0800
Message-ID: <CAF0htA7TeuKjQzU9EE5_RWUkznf+Xp=CsGd=TA6qB0COQxUYQg@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig parameter
From: Lennox Wu <lennox.wu@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because I don't think droping it is meaningful, since it will be used.
Moreover, the symbol never affect other architectures or subsystems.
I feel that is not good to brother people to process the unimportant patch.

Best,
Lennox


2014-03-09 4:00 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
> Lennox,
>
> On Sat, 2014-03-08 at 14:34 +0800, Lennox Wu wrote:
>> According to my record, I had told you we have another
>> processor(2013/11/4), hence, we need the parameter.
>> We just wirte it done first. Do you remember it?
>
> In https://lkml.org/lkml/2011/11/12/76 I already reported that this
> Kconfig symbol was unused. Why can't it be dropped and re-added when
> code is added to the tree that actually uses it?
>
>
> Paul Bolle
>
