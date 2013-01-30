Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3A3Ts7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:48:59 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:56930 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3A3Ts4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:48:56 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301301940.r0UJeEKa016044@como.maths.usyd.edu.au>
Date: Thu, 31 Jan 2013 06:40:14 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301301940.r0UJeEKa016044@como.maths.usyd.edu.au>
To: dave@linux.vnet.ibm.com, pavel@ucw.cz
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <51093D03.8070006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Pavel and Dave,

> The assertion was that 4GB with no PAE passed a forkbomb test (ooming)
> while 4GB of RAM with PAE hung, thus _PAE_ is broken.

Yes, PAE is broken. Still, maybe the above needs slight correction:
non-PAE HIGHMEM4G passed the "sleep test": no OOM, nothing unexpected;
whereas PAE OOMed then hung (tested with various RAM from 3GB to 64GB).

The feeling I get is that amd64 is proposed as a drop-in replacement for
PAE, that support and development of PAE is gone, that PAE is dead.

Cheers, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
