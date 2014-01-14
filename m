Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaANQq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:46:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16737 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752442AbaANQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:24 -0500
Date: Tue, 14 Jan 2014 11:40:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Bor?? <jdb@sitrep3.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20140114164019.GD13710@home.goodmis.org>
References: <1388425244-10017-1-git-send-email-jdb@sitrep3.com>
 <20140109183909.GA10563@kroah.com>
 <CAFFYk1WCjOt4ftS30ZWVkYLjqxC-CBtbp3OeJ2HDinu4gu_d2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFFYk1WCjOt4ftS30ZWVkYLjqxC-CBtbp3OeJ2HDinu4gu_d2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:49:39PM +0000, Joe Bor?? wrote:
> 
> I didn't do the changes as root, I sent them from my server as it has SMTP out.
> 

Hmm, this gives me an idea. There's nothing, I believe, that makes the root user
have to have the name "root" except for the passwd file. Maybe I'll just
rename "root" to "walley" and then use "root" as my normal account. If anyone tries
to break into "root" they will just gain access to a normal account and nothing
more ;-)

/me goes back to hacking

-- Steve

