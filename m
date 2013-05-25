Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab3EYPUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:20:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60519 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab3EYPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:20:31 -0400
MIME-Version: 1.0
X-Originating-IP: [114.40.26.198]
In-Reply-To: <4528298.O99iVSpig9@avalon>
References: <1369057541.11578.1.camel@phoenix>
	<20130523013933.GI22608@verge.net.au>
	<20130523191217.GB17462@avionic-0098.adnet.avionic-design.de>
	<4528298.O99iVSpig9@avalon>
Date: Sat, 25 May 2013 23:20:30 +0800
Message-ID: <CAFRkauD6jgaETfnFcekJsM1irvCq45bes-Gt7BL1EP36G9+5rg@mail.gmail.com>
Subject: Re: [PATCH v2] pwm: renesas-tpu: Add missing pwmchip_remove() call in tpu_remove()
From: Axel Lin <axel.lin@ingics.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Horman <horms@verge.net.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/25 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Thierry,
>
> On Thursday 23 May 2013 21:12:17 Thierry Reding wrote:
>> On Thu, May 23, 2013 at 10:39:34AM +0900, Simon Horman wrote:
>> > On Mon, May 20, 2013 at 03:46:59PM +0200, Laurent Pinchart wrote:
>> > > Hi Axel,
>> > >
>> > > Thank you for the patch.
>> > >
>> > > On Monday 20 May 2013 21:45:41 Axel Lin wrote:
>> > > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> > >
>> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> >
>> > Thanks. I have queued this up for v3.11 in the pinmux branch
>> > of my renesas tree on kernel.org.
>>
>> I'd rather take this through the PWM tree along with the original driver
>> patch.
>
> As I will need to submit a new version of the renesas-tpu patches should I
> fold this patch in ?

Hi Laurent,
I think you can fold this patch in if you are going to submit a new version
of the renesas-tpu patches.

Regards,
Axel
