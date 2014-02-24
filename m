Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaBXFce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:32:34 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:46586 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaBXFcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:32:33 -0500
Date: Mon, 24 Feb 2014 05:32:32 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH for-next 2/4] epoll: epoll() syscall declaration
Message-ID: <20140224053232.GB7056@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
 <1393206162-18151-3-git-send-email-n1ght.4nd.d4y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393206162-18151-3-git-send-email-n1ght.4nd.d4y@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> +asmlinkage long sys_epoll(int ep, struct epoll __user *in,
> +			  unsigned int inc, struct epoll __user *out,
> +			  unsigned int outc, int timeout);

I can understand using the new struct for 'in', but 'out' could just be
"struct epoll_event *" like sys_epoll_wait, right?

>  asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
