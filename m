Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaJHVbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:31:02 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51354 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaJHVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:30:59 -0400
Date: Wed, 8 Oct 2014 14:30:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Leitner <me@g0hl1n.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: Re: [PATCH] input: avoid negative input device numbers
Message-ID: <20141008213051.GD15198@dtor-ws>
References: <20141008224245.601a1339@frodo>
 <20141008212538.GB15198@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008212538.GB15198@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 02:25:38PM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 08, 2014 at 10:42:45PM +0200, Richard Leitner wrote:
> > From: Richard Leitner <richard.leitner@skidata.com>
> > 
> > Fix the format string for input device name generation to avoid negative
> > device numbers when the id exceeds the maximum signed integer value.
> 
> Well, it is going to take us a while to get there :)
> 
> Applied, thank you.

By the way, we have similar issue in serio and gameport code, mind
sending fixes for them as well?

Thanks.

-- 
Dmitry
