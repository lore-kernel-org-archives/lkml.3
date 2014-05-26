Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaEZOpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:45:10 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:6971 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaEZOpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:45:09 -0400
Message-ID: <1401115505.7240.11.camel@wisdom>
Subject: Re: [PATCH 1/3] staging: panel: (coding style) Matching braces
From: Dominique van den Broeck <domdevlin@free.fr>
Reply-To: domdevlin@free.fr
To: Willy Tarreau <w@1wt.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 16:45:05 +0200
In-Reply-To: <20140526142827.GG13929@1wt.eu>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
	 <20140526142827.GG13929@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Willy,

> I don't want to be nit-picking, but since we're talking about style...
> for me these "} else {" statements are harder to parse than having them
> on two lines this way :
> <...>
>
> It's just a matter of taste I know, but for me they read easier, probably
> because the braces do not affect alignment and the lines appear exactly
> similar with or without the braces.

I don't mind at all about this. 

Even if I'm into C code for quite a long time now, I'm still new in kernel
development (just completed the Eudyptula Challenge) and I thought it could
be both a harmless and useful way to start contributing and get used with it
to focus a bit on ./checkpatch.pl suggestions (which is the actual entity to
blame about it).

This is the reason why I submitted the patch but it's not a personal
preference. If you prefer these braces laid out the older way, I'll let
them as is next time. If there's another usages I should know about, just
let me know.

Cheers.


