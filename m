Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaCMAxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:53:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:27854 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751598AbaCMAx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:53:28 -0400
Date: Wed, 12 Mar 2014 20:53:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Laurent Chavey <chavey@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix array size mismatch in format string
Message-ID: <20140312205327.74cb20ca@gandalf.local.home>
In-Reply-To: <CAL26m8LojQppYpQGhbZsAw7Qt1BrphBo=k+fcSZVdCctdzxF_Q@mail.gmail.com>
References: <1392349908-29685-1-git-send-email-vnagarnaik@google.com>
	<CAL26m8LojQppYpQGhbZsAw7Qt1BrphBo=k+fcSZVdCctdzxF_Q@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 17:16:20 -0700
Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:

> Hi Steven,
> 
> Any chance you can take a look at this patch?
> 

Grumble, I thought I pulled this in already. I may have been working on
it and then got distracted by my day job, and it got lost in the
shuffle.

Your timing here isn't that great either, because I leave tomorrow for
another conference, and I'm currently trying to get everything ready
for that trip. Could you ping me again on Tuesday?

Thanks,

-- Steve
