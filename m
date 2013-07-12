Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab3GLTtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:49:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3GLTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:49:14 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=ZtoO9_VWJFZgB38_bYgA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373658551.17876.117.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Fri, 12 Jul 2013 15:49:11 -0400
In-Reply-To: <20130712193557.GB342@thunk.org>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <20130712173150.GA5534@roeck-us.net>
	 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	 <20130712181103.GA6689@roeck-us.net> <20130712193557.GB342@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 15:35 -0400, Theodore Ts'o wrote:

> So the problem is that maintainers are lazy.  They don't want to go
> back for bug fixes that have "proven" themselves, and even if they
> aren't critical bug fixes, they are things which a distro maintainer
> or a stable kernel user might want (and sometimes stable uers are
> uppity enough to expect subsystem maintainers to do this back
> porting).  So subsystem maintainers then react by marking submits for
> stable even though they really should soak for a release or two before
> submitting them, since by marking them as submit, the commit gets
> pushed to stable automatically --- albeit early.

Actually, this is a very good point. There were one or two stable
patches I had pushed to linux-next that I wasn't too comfortable about.
If the fix goes back to older trees, I rather have them stirring in
linux-next and push it in the next merge window instead of pushing it to
Linus and have it go to stable immediately.

Unless its a obvious fix, I tend to take about a month from the time I
get a stable fix to the time I push it out. Making sure the stable fix
doesn't introduce new bugs.

-- Steve


