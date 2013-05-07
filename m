Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab3EGMaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:30:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3EGMaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:30:16 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=slPD7z3sIfwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=3xO3pHl8zQEA:10 a=Z4Rwk6OoAAAA:8 a=LNaclEAlAAAA:8 a=PyRFuKKJ3_q1AHMFSVQA:9 a=QEXdDO2ut3YA:10 a=AUilTyUHL0gA:10 a=iCipCs-3YsAA:10 a=t2YydbHNi0cA:10 a=TEPOqWUp2fEA:10 a=jbrJJM5MRmoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367929814.7373.50.camel@gandalf.local.home>
Subject: Re: [094/126] TTY: fix atime/mtime regression
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 07 May 2013 08:30:14 -0400
In-Reply-To: <5188A739.8080309@suse.cz>
References: <20130507035712.909872333@goodmis.org>
	 <20130507035856.682670331@goodmis.org> <5188A739.8080309@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 09:03 +0200, Jiri Slaby wrote:
> On 05/07/2013 05:58 AM, Steven Rostedt wrote:
> > 3.6.11.3 stable review patch.
> > If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jiri Slaby <jslaby@suse.cz>
> > 
> > [ Upstream commit 37b7f3c76595e23257f61bd80b223de8658617ee ]
> 
> Hi, you also want this one:
> commit b0b885657b6c8ef63a46bc9299b2a7715d19acde
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed May 1 07:32:21 2013 -0700
> 
>     tty: fix up atime/mtime mess, take three
> 

Heh, thanks. I may add it. I'm usually behind Greg's releases by one.
I'm sure he's adding this to his 3.9.1 series, and I haven't pulled his
stuff in. I've based this off of 3.8.11.

I may just leave this out and pull it in on 3.6.11.4 when I use the 3.9
series.

But thanks for letting me know. I haven't totally decided yet.

-- Steve


