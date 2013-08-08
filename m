Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965937Ab3HHQWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:22:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3HHQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:22:09 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pR7EoCbdL7wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=paP5AUKnsW4A:10 a=VwQbUJbxAAAA:8 a=OsHSFiwwcUUHc0Yb8woA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=M7Ta1CmRqBkA:10 a=Yc-5cZ3Dw50A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375978928.6848.67.camel@gandalf.local.home>
Subject: Re: [PATCH] Revert "slub: do not put a slab to cpu partial list
 when cpu_partial is 0"
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Date: Thu, 08 Aug 2013 12:22:08 -0400
In-Reply-To: <CA+55aFzdg0L6VfYsTz9HdqVwd-80u1cet7sTe7YnMtroXcxmRw@mail.gmail.com>
References: <1375967992.6848.55.camel@gandalf.local.home>
	 <CAOJsxLHCVER8MX=wbwqUTe+MfoxtAu-X3CtUA=9uFyz+q+XtsQ@mail.gmail.com>
	 <CA+55aFzdg0L6VfYsTz9HdqVwd-80u1cet7sTe7YnMtroXcxmRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 09:12 -0700, Linus Torvalds wrote:
> On Thu, Aug 8, 2013 at 7:35 AM, Pekka Enberg <penberg@kernel.org> wrote:
> >
> > Linus, can you pick this up or do you want a pull request?
> 
> I just did the revert when reading the original thread, and hadn't
> even gotten to this new email thread with an actual patch.
> 
> Anyway, it's reverted in my tree,
> 

Cool, thanks!

-- Steve


