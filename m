Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3ARX2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:28:00 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:51956 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3ARX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:27:58 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130116123502.70af6b85.akpm@linux-foundation.org>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
 <1358182435-19245-3-git-send-email-avagin@openvz.org> <20130116123502.70af6b85.akpm@linux-foundation.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 19 Jan 2013 00:27:38 +0100
Message-ID: <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As SFD_RAW is being added to the kernel API we should document it.
> Please keep Michael cc'ed and work with him on getting the manpages
> updated.

The API is certainly no thing of beauty, as I already remarked here:
http://thread.gmane.org/gmane.linux.file-systems/70420/focus=1420228

A description of the API can be found here:
https://lwn.net/Articles/531939/

The main problem is the ugliness of changing the meaning of pread()'s
'offset' argument to be a multiplexed [signal queue selector + queue
position].

I do wonder if we can do better, though I have no particular solution
to offer beyond the sledgehammer of adding a new system call.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
