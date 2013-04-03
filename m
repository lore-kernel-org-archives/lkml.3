Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616Ab3DCC4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:56:12 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:53477 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231Ab3DCC4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130403022939.GL24039@S2101-09.ap.freescale.net>
References: <1364920232-9604-1-git-send-email-fabio.estevam@freescale.com>
	<20130403022939.GL24039@S2101-09.ap.freescale.net>
Date: Wed, 3 Apr 2013 10:56:11 +0800
Message-ID: <CAAQ0ZWQrrGhhwEMg_0ifMLZdgB4u6d7c4QqyejgRphRx5Mft6A@mail.gmail.com>
Subject: Re: [PATCH] clocksource: mxs_timer: Add semicolon at end of line
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 10:29, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Apr 02, 2013 at 01:30:32PM -0300, Fabio Estevam wrote:
>> Fix the following build error:
>>
>> drivers/clocksource/mxs_timer.c:304:1: error: expected ',' or ';' at end of input
>>
> What's your gcc version?  I'm using gcc version 4.6.3 (Ubuntu/Linaro
> 4.6.3-1ubuntu5), and do not see the compile error.

Ok, I'm seeing the error now on linux-next. It's not about compiler
but the commit 3d5a965 (clocksource: make CLOCKSOURCE_OF_DECLARE type
safe), which removes the semicolon at end of the
CLOCKSOURCE_OF_DECLARE definition.

Shawn
