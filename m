Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaK0SIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:08:24 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:42473 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaK0SIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:08:22 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <201411251208.31658@pali>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <201411170839.17504@pali> <201411200029.49547@pali> <201411251208.31658@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 0/7] Fixes for ALPS trackstick
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu, 27 Nov 2014 10:08:04 -0800
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <DD50BA4C-4E7C-4E69-9A79-52C2B577F580@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 25, 2014 3:08:31 AM PST, "Pali Rohár" <pali.rohar@gmail.com> wrote:
>On Thursday 20 November 2014 00:29:49 Pali Rohár wrote:
>> On Monday 17 November 2014 08:39:14 Pali Rohár wrote:
>> > On Friday 14 November 2014 21:59:31 Dmitry Torokhov wrote:
>> > > Hi Pali,
>> > > 
>> > > On Friday, November 14, 2014 08:38:19 PM Pali Rohár wrote:
>> > > > This patch series fix detection and identifying
>> > > > trackstick on machines with ALPS devices. Last patch
>> > > > split trackstick and bare PS/2 mouse packets between
>> > > > dev2 and dev3 input devices which make sure that driver
>> > > > will send only trackstick data to trackstick input
>> > > > device.
>> > > 
>> > > Thank you for splitting the change, unfortunately it is
>> > > now quite big to apply to 3.18. Any chance you could try
>> > > implementing what I suggested in
>> > > http://www.spinics.net/lists/linux-input/msg34029.html and
>> > > then we can do the more comprehensive solution in 3.19.
>> > > 
>> > > Thanks.
>> > 
>> > Hello, I think that patches 1/7 and 5/7 could do that job. I
>> > did not tested them alone (without other patches), but if
>> > you think that two patches are ok for 3.18 & stable I can
>> > test them...
>> 
>> Dmitry, ping.
>
>Dmitry: ping again.

Hi Pali,

I'm on vacation and unfortunately connection here is horrendous so I likely won't be able to do anything until after 12/03.

Sorry about that.


-- 
Dmitry
