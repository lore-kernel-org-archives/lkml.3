Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3IJIaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:30:35 -0400
Received: from trent.utfs.org ([94.185.90.103]:53608 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab3IJIad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:30:33 -0400
Date: Tue, 10 Sep 2013 01:30:28 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: LKML <linux-kernel@vger.kernel.org>, Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: proc hidepid=2 and SGID programs
In-Reply-To: <87r4cybio2.fsf@xmission.com>
Message-ID: <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org> <87r4cybio2.fsf@xmission.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Sep 2013 at 23:42, Eric W. Biederman wrote:
> I don't have a clue why anyone would want to hide processes, and make
> their own lives more difficult.

Oh, there are plenty of usescases, I'm sure. And I for one am thankful 
that this process hiding option made it into the kernel. Or, to answer in 
another way: why would anyone want to see other peoples processes?

> The check with hidepid is can you ptrace the process.  I expect there
> is something with those sgid processes that keeps you from ptracing
> them.

Indeed, I cannot strace the process. But still, I wonder if this is 
intended behaviour.
 
> Of course if you don't like the silly behavior you can always disable
> it.

:-)

C.
-- 
BOFH excuse #412:

Radial Telemetry Infiltration
