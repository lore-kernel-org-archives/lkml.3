Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaAEW1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:27:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34127 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaAEW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:27:54 -0500
Date: Sun, 5 Jan 2014 23:27:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, joe@perches.com, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-ID: <20140105222752.GA27517@amd.pavel.ucw.cz>
References: <201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
 <CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
 <1388770748.14334.19.camel@joe-AO722>
 <CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
 <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
 <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> + * Please use this wrapper function which will be updated in the future to read
> + * @tsk->comm in a consistent way.
> + */
> +static inline int commcmp(const struct task_struct *tsk, const char *comm)
> +{
> +	return strcmp(tsk->comm, comm);
> +}

Is this useful to something? Printing command name is
useful. Comparing it...?
										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
