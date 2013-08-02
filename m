Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3HBOEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:04:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3HBOEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:04:21 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=NSj8eXRFd_AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qfOha8plvAIA:10 a=tUZEq0HuJNYCr25LDbMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375452259.22073.3.camel@gandalf.local.home>
Subject: Re: [for-next-3.11][PATCH 0/5] tracing: Final fixes for the race
 between open event file and deleting event
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 02 Aug 2013 10:04:19 -0400
In-Reply-To: <20130802134530.GA18839@redhat.com>
References: <20130802024924.999067099@goodmis.org>
	 <20130802134530.GA18839@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 15:45 +0200, Oleg Nesterov wrote:
> On 08/01, Steven Rostedt wrote:
> >
> > Is all the races that we are aware of between accessing event files and
> > deleting events covered by these patches?  I think I have them all.
> 
> Yes, I believe this covers all problems we discussed. I am not aware
> of any other problem in this area.

Great! I just pushed this to for-next. I'll let it sit there for over
the weekend, and if there's no more issues, I'll push this off to Linus.

Hopefully this will be the last of the changes needed for 3.11 :-)

I'll then need to look at all the changes made and put together a set of
changes to send to stable. I didn't mark any of these with stable as
there's lots of dependencies I need to figure out and some of these
fixes need to go back quite a ways.

Thanks for all your help (you and Masami :-)

-- Steve


