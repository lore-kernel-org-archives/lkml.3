Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3HPLle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:41:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55144 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3HPLla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:41:30 -0400
Date: Fri, 16 Aug 2013 13:41:25 +0200
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, mujeeb.adil@gmail.com,
        harsh1kumar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Staging: winbond: wb35reg: changed sleep function
 from msleep to usleep
Message-Id: <20130816134125.c1afc15faee7ee277ff8eeb7@gmail.com>
In-Reply-To: <20130812100510.GA21492@amd.pavel.ucw.cz>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
	<1375696712-5276-2-git-send-email-ikerpedrosam@gmail.com>
	<20130812100510.GA21492@amd.pavel.ucw.cz>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/timers/timers-howto.txt it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.

On Mon, 12 Aug 2013 12:05:10 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2013-08-05 11:58:27, Iker Pedrosa wrote:
> > Changed sleep function from msleep to usleep according to the documentation.
> > 
> > Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
> 
> Can you explain why this is good idea?
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


-- 
Regards,

Iker Pedrosa <ikerpedrosam@gmail.com>
