Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3LPS2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:28:08 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60896 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3LPS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:28:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131216172710.GA1811@roeck-us.net>
References: <20131121173458.GC10783@roeck-us.net>
	<CAOMwXhNzpsiiK5NzxoXM56ACGmHo1gpm3OT6=kw29XQDFmyPAA@mail.gmail.com>
	<CAOMwXhPUR02fQ1EhV6K9eQW02kNHn55dTEND+R59g1=zC5qDWQ@mail.gmail.com>
	<528F6BB8.8040504@roeck-us.net>
	<CAOMwXhNx0v52BvxSWPrHFsGTvxss7N4tZT3gHMFJ8hz_HmvS5w@mail.gmail.com>
	<20131122160457.GA3951@roeck-us.net>
	<CAOMwXhO525BAJ+ESLaJ-62vkL7mAxLMULuaphE6YVda02beqfg@mail.gmail.com>
	<20131122180501.GA8547@roeck-us.net>
	<CAOMwXhO_D3cR5QfXp3wZGrO+i85X5H=Q0HAr2VCB6=96nLx4yQ@mail.gmail.com>
	<CAOMwXhPDgw4Cex-_ORh26VVN93L_kxApoNzGe4M+r2Vm6HGB=A@mail.gmail.com>
	<20131216172710.GA1811@roeck-us.net>
Date: Mon, 16 Dec 2013 18:28:05 +0000
X-Google-Sender-Auth: uTs1EYL6OcXOkcVyT3g-_nJVM60
Message-ID: <CAOMwXhMkgzqK7PHGhW441NOOR_9iwZYoLG-Qki6yv4bsA3zBWQ@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Add support for gpiodef
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>, hjk@hansjkoch.de,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 5:27 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Mon, Dec 16, 2013 at 03:56:33PM +0000, Laszlo Papp wrote:
>> So, Mr. Roeck, how do you suggest to handle input or output port
>> configuration? Should it be coming from platform data, or should it be
>> more dynamic? I would say, it is usually static, but I do not know if
>> it is common to be dynamic. I am not a hardware designer.
>>
>
> Platform and/or devicetree.

Works for me. Should I apply the gpio and mfd drivers separately or in
one single patch?
