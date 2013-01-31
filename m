Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3AaJId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:08:33 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:51831 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3AaJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:07:47 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301310907.r0V974j9017335@como.maths.usyd.edu.au>
Date: Thu, 31 Jan 2013 20:07:04 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301310907.r0V974j9017335@como.maths.usyd.edu.au>
To: 695182@bugs.debian.org, ben@decadent.org.uk
Subject: Re: Bug#695182: [RFC] Reproducible OOM with just a few sleeps
Cc: dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pavel@ucw.cz
In-Reply-To: <1359609334.31386.40.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ben,

Thanks for the repeated explanations.

> PAE was a stop-gap ...
> ... [PAE] completely untenable.

Is this a good time to withdraw PAE, to tell the world that it does not
work? Maybe you should have had such comments in the code.

Seems that amd64 now works "somewhat": on Debian the linux-image package
is tricky to install, and linux-headers is even harder. Is there work
being done to make this smoother?

---

I am still not convinced by the "lowmem starvation" explanation: because
then PAE should have worked fine on my 3GB machine; maybe I should also
try PAE on my 512MB laptop. - Though, what do I know, have not yet found
the buggy line of code I believe is lurking there...

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
