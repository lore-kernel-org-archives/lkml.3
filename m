Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3LPTzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:55:36 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57534 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3LPTze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:55:34 -0500
Date: Mon, 16 Dec 2013 11:55:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>, hjk@hansjkoch.de,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Add support for gpiodef
Message-ID: <20131216195533.GA6462@roeck-us.net>
References: <528F6BB8.8040504@roeck-us.net>
 <CAOMwXhNx0v52BvxSWPrHFsGTvxss7N4tZT3gHMFJ8hz_HmvS5w@mail.gmail.com>
 <20131122160457.GA3951@roeck-us.net>
 <CAOMwXhO525BAJ+ESLaJ-62vkL7mAxLMULuaphE6YVda02beqfg@mail.gmail.com>
 <20131122180501.GA8547@roeck-us.net>
 <CAOMwXhO_D3cR5QfXp3wZGrO+i85X5H=Q0HAr2VCB6=96nLx4yQ@mail.gmail.com>
 <CAOMwXhPDgw4Cex-_ORh26VVN93L_kxApoNzGe4M+r2Vm6HGB=A@mail.gmail.com>
 <20131216172710.GA1811@roeck-us.net>
 <CAOMwXhMkgzqK7PHGhW441NOOR_9iwZYoLG-Qki6yv4bsA3zBWQ@mail.gmail.com>
 <CAOMwXhN5pdUO1B56LVG=pA5-3ag9K=Ly8QQs-pog0iP2JnOczw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhN5pdUO1B56LVG=pA5-3ag9K=Ly8QQs-pog0iP2JnOczw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 06:28:34PM +0000, Laszlo Papp wrote:
> On Mon, Dec 16, 2013 at 6:28 PM, Laszlo Papp <lpapp@kde.org> wrote:
> > On Mon, Dec 16, 2013 at 5:27 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> On Mon, Dec 16, 2013 at 03:56:33PM +0000, Laszlo Papp wrote:
> >>> So, Mr. Roeck, how do you suggest to handle input or output port
> >>> configuration? Should it be coming from platform data, or should it be
> >>> more dynamic? I would say, it is usually static, but I do not know if
> >>> it is common to be dynamic. I am not a hardware designer.
> >>>
> >>
> >> Platform and/or devicetree.
> >
> > Works for me. Should I apply the gpio and mfd drivers separately or in
> > one single patch?
> 
> s/apply/send/
> 
Separately.

Guenter
