Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3BDT73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:59:29 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:60921 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3BDT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:59:28 -0500
Date: Mon, 4 Feb 2013 20:59:26 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: syrine tlili <syrine.tl@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Unchecked Null pointers
In-Reply-To: <CAETb2JP0z7JKnuiu==PeVMugr2NS1jgAsisXEc+59w0K=4tSrw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1302042053400.21762@swampdragon.chaosbits.net>
References: <CAETb2JP0z7JKnuiu==PeVMugr2NS1jgAsisXEc+59w0K=4tSrw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, syrine tlili wrote:

> Hi:
> I would like to report a set of errors found in the source tree of
> Linux version 3.0.52 using a static analysis tool for vulnerability
> detection that I'm developing  based on GCC.

Cool. New useful tools are always nice. Where can I download it/look at 
its source code?


> I have performed the security analysis on the whole linux 3.0.52
> distribution and my tool detected 18 errors related to the use of
> unchecked potential  null pointers.

May I suggest that you run your tool against a more recent code-base, such 
as the lastest stable kernel (atm 3.7.6) or the latest 3.8-rc kernel 
(currently 3.8-rc6) or a daily snapshor of Linus' kernel.
That may gain you more feedback from people.


> Some of these errors are also present in recent kernel versions such
> as version 3.6.4
> Details on the detected errors are listed below.
> I'm looking forward to getting your feedback on the reported errors.
> 
[...]

I'd suggest, that a more useful way of getting feedback would be to run 
the tool against a more recent (relevant) kernel source and then submit 
actual patches attempting to *fix* the problems you find. That would be 
more likely to get peoples attention - and would also potentially result 
in some nice fixes being merged.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

