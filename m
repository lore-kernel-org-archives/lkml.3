Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaHYK3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:29:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52036 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaHYK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:29:35 -0400
Date: Mon, 25 Aug 2014 12:29:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] checkpatch.pl: New instances of ENOSYS are errors
Message-ID: <20140825102932.GA5772@amd>
References: <72714b6b69d00496d6e55453423c4070de292bf4.1408724662.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72714b6b69d00496d6e55453423c4070de292bf4.1408724662.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-22 09:26:31, Andy Lutomirski wrote:
> ENOSYS means that a nonexistent system call was called.  We have a
> bad habit of using it for things like invalid operations on
> otherwise valid syscalls.  We should avoid this in new code.

Is it good idea? I mean, doing EINVAL for subcalls is pretty
unhelpful.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
