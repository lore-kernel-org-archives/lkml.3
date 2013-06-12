Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab3FLB3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:29:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab3FLB3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:29:00 -0400
Date: Tue, 11 Jun 2013 18:28:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Raphael S. Carvalho" <raphael.scarv@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/pid.c: Masking the flag out to get the
 actual value.
Message-Id: <20130611182831.8d6d25be.akpm@linux-foundation.org>
In-Reply-To: <8761xkt9fh.fsf@xmission.com>
References: <1370901398-8989-1-git-send-email-raphael.scarv@gmail.com>
	<20130611154518.fda9262961c21e96a57cbd5e@linux-foundation.org>
	<8761xkt9fh.fsf@xmission.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013 18:16:50 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> > Hopefully we can fix this one by adding the missing comment.
> 
> Perhaps we can fix this one by having people who care read the code and 
> think about what it means?

As is obvious from this thread, that approach isn't working.

>  Seriously if we are adding pids/processes in
> the pid namespace why would to clean up the pid namespace?

A good way to communicate the design would be to describe the semantics
of PIDNS_HASH_ADDING, at its definition site.

[idly wonders what the heck pid_namespace.level and pid.level do, sigh]
