Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897Ab3DPQKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:10:13 -0400
Received: from mail-a03.ithnet.com ([217.64.83.98]:55338 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S935469Ab3DPQKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:10:11 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Tue, 16 Apr 2013 18:10:06 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: No serial since kernel 3.8
Message-Id: <20130416181006.6be492a8.skraw@ithnet.com>
In-Reply-To: <CAFLxGvykqMUHrmdZnzPXW7i3-ubcF6jv2fLYF3sYPkCtJDJZuA@mail.gmail.com>
References: <20130416162047.2f9b83fe.skraw@ithnet.com>
	<CAFLxGvykqMUHrmdZnzPXW7i3-ubcF6jv2fLYF3sYPkCtJDJZuA@mail.gmail.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 16:55:25 +0200
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> On Tue, Apr 16, 2013 at 4:20 PM, Stephan von Krawczynski
> <skraw@ithnet.com> wrote:
> > Hello,
> >
> > can some kind soul please explain how I can get my serial port back under
> > kernel 3.8.X. Earlier kernels showed:
> >
> > Jan 10 13:57:18 mybox kernel: [    0.712829] serial8250: ttyS0 at I/O 0x3f8
> > (irq = 4) is a 16550A
> >
> > But 3.8.4:
> >
> > Mar 26 10:39:14 admin kernel: [    0.603647] serial 00:0a: disabled
> >
> > Only kernel is replaced, no change in distro
> > Is there some kernel boot parameter needed now?
> > I tried 3.4.X and it works, even 3.7.X works...
> 
> So, 3.8.3 worked and 3.8.4 introduced a regression?
> If so please confirm.
> 
> CC'ing gregkh, just in case...

No, neither 3.8.4 nor 3.8.3 worked. The last working version I know for sure is 3.7.6
FYI: I don't load serial as a module
-- 
Regards,
Stephan
