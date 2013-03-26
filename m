Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab3CZFAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 01:00:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3CZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 01:00:50 -0400
Date: Mon, 25 Mar 2013 22:01:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] drivers: virtio: Use PTR_RET function
Message-Id: <20130325220150.af9795a7.akpm@linux-foundation.org>
In-Reply-To: <87fvzidenm.fsf@rustcorp.com.au>
References: <1364217936-6284-1-git-send-email-gheorghiuandru@gmail.com>
	<87fvzidenm.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 13:57:09 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Alexandru Gheorghiu <gheorghiuandru@gmail.com> writes:
> 
> > Used PTR_RET function instead of IS_ERR and PTR_ERR.
> > Patch found using coccinelle.
> 
> WTF is PTR_RET?  PTR_RET doesn't return anything.  Why is it called
> that?  It doesn't even make sense.
> 
> ZERO_OR_PTR_ERR() maybe.
> 
> But what problem are we solving?  Insufficient churn in the tree?  Code
> being too readable?  This isn't some hard-to-get right corner case, or a
> missed optimization.
> 
> Andrew, what am I missing here?

It seemed like a good idea at the time.  Merged it two years ago and
have since been keenly awaiting an opportunity to use it.

It seems that people _have_ been using it, but mainly netfilter people
and we know they're all crazy ;)

