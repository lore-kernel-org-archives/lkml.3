Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3BADNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:13:54 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:38086 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3BADNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:13:53 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201302010313.r113DTj3027195@como.maths.usyd.edu.au>
Date: Fri, 1 Feb 2013 14:13:29 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201302010313.r113DTj3027195@como.maths.usyd.edu.au>
To: ben@decadent.org.uk
Subject: Re: Bug#695182: [RFC] Reproducible OOM with just a few sleeps
Cc: 695182@bugs.debian.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pavel@ucw.cz
In-Reply-To: <1359687434.31386.53.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ben,

>>>> PAE is broken for any amount of RAM.
>>> No it isn't.
>> Could I please ask you to expand on that?
>
> I already did, a few messages back.

OK, thanks. Noting however that fewer than those back, I said:
  ... PAE with any RAM fails the "sleep test":
  n=0; while [ $n -lt 33000 ]; do sleep 600 & ((n=n+1)); done
and somewhere also said that non-PAE passes. Does not that prove
that PAE is broken?

Cheers, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
