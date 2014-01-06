Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaAFWKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:10:37 -0500
Received: from blu0-omc1-s33.blu0.hotmail.com ([65.55.116.44]:32509 "EHLO
	blu0-omc1-s33.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042AbaAFWKf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:10:35 -0500
X-TMN: [GxtLce+RhdFuY/o9SqpWxqF5DVS7RIWA]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W27FA5477DF3AA1C93A75C0ACB70@phx.gbl>
From: Joe Xue <lgxue@hotmail.com>
To: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH v3 1/1] leds: Add LED pattern trigger
Date: Mon, 6 Jan 2014 17:10:34 -0500
Importance: Normal
In-Reply-To: <1389044834-22870-1-git-send-email-lgxue@hotmail.com>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>,<1389044834-22870-1-git-send-email-lgxue@hotmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Jan 2014 22:10:34.0623 (UTC) FILETIME=[1F2838F0:01CF0B2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Xue <lgxue@hotmail.com>
>
> The LED pattern trigger allows LEDs blink in user defined pattern.
>
> v2: Change the pattern memory from fixed static to malloc
> Change the timer schedule way to save cpu time
> Add the mutex to protect the pattern operation
>
> v3: Tiny fix, add the missed parameter in example of document
>
> new file: Documentation/leds/ledtrig-pattern.txt
> modified: drivers/leds/trigger/Kconfig
> modified: drivers/leds/trigger/Makefile
> new file: drivers/leds/trigger/ledtrig-pattern.c
>
> Signed-off-by: Joe Xue <lgxue@hotmail.com>
> ---

Forgot to add suggested-by line:

Suggested-by: Pavel Machek <pavel@ucw.cz>

I would like to give too much credit to this buddy.

Joe 		 	   		  