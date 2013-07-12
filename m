Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259Ab3GLRvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:51:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778Ab3GLRvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:51:00 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=HICIQ9bjhMYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PINbNDQYIjoA:10 a=4DzLHtMEDxaBvQPYrTQA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373651458.17876.103.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Date: Fri, 12 Jul 2013 13:50:58 -0400
In-Reply-To: <20130712172836.GA7627@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com>
	 <20130712033430.GA3798@kroah.com> <51E03AEE.5010403@zytor.com>
	 <20130712172836.GA7627@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 10:28 -0700, Greg Kroah-Hartman wrote:

> Yes, this requires you to remember to do this after it hits Linus's
> tree, so you could do like David does for networking, and keep a
> seperate tree to send to me specifically for stable patches.  I think he
> uses patchwork, but I know others use git for this, and that's fine as
> well.

Perhaps just make a separate stable branch, where you cherry-pick the
specific patch using the -x option. Adds a "(cherry picked from
commit ...)". Then you could have some filter that monitors Linus
commits and when a commit matches one of these patches, have it
automatically sent to the stable list.


-- Steve


