Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaADWdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 17:33:01 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33537 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaADWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 17:32:59 -0500
Date: Sat, 4 Jan 2014 14:32:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
Message-ID: <20140104223256.GB18213@core.coreip.homeip.net>
References: <20140104052756.GA32561@core.coreip.homeip.net>
 <CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
 <20140104061650.GB20272@core.coreip.homeip.net>
 <CAHQ1cqEQtXRaPWo6wYgpDrjwGhnAySvb7Jvs8KFRTTRb3g++GQ@mail.gmail.com>
 <20140104074621.GD20272@core.coreip.homeip.net>
 <CAHQ1cqEmpejiMPij+jQM0YEceShyHPRJ2dPkuaLkuBLYLXQyJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqEmpejiMPij+jQM0YEceShyHPRJ2dPkuaLkuBLYLXQyJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 09:41:43AM -0800, Andrey Smirnov wrote:
> 
> Anyway, TL;DR of the whole thing is:
>  - Your arguments do not convince me in the slightest
>  - I don't think that mine do you
>  - Let's stop wasting out time
>  - Do as you see fit, since you are the maintainer
> 

Nah, I think I'll drop the patch for now, that macro is a bit ugly and
as you said the code is not in a hot path. I'll reserve the right to
revisit it based on how accelerometer code looks.

Thanks.

-- 
Dmitry
