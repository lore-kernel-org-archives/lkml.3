Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab3GLU2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:28:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10810 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab3GLU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:28:22 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=NDrTxKufa2qlFP5fwHEA:9 a=QEXdDO2ut3YA:10 a=BdJ62hfUT2UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373660900.17876.124.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Fri, 12 Jul 2013 16:28:20 -0400
In-Reply-To: <20130712201939.GB15261@redhat.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <20130712173150.GA5534@roeck-us.net>
	 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	 <20130712181103.GA6689@roeck-us.net> <20130712193557.GB342@thunk.org>
	 <1373658551.17876.117.camel@gandalf.local.home>
	 <20130712201939.GB15261@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 16:19 -0400, Dave Jones wrote:

> Your example above: If that fix was for "tracing reports wrong results", no big deal,
> everyone can live with it for a month. If it was fixing "a bug in tracing can allow
> an unprivileged user to crash the kernel", a month is unacceptable, and at
> the least we should be getting an interim fix to mitigate the problem.

And even that isn't one size fits all. If the exploit is a -rc only, or
even a newly released kernel. Is it that critical to get it fixed ASAP?
I would think that the kernel releases takes time before they get to
users main machines.

I would suspect that machines that allow unprivileged users would be
running distro kernels, and not the latest release from Linus, and thus
even a bug that "can allow an unprivileged user to crash the kernel" may
still be able to sit around for a month before being submitted.

This wouldn't be the case if the bug was in older kernels that are being
used.

-- Steve


