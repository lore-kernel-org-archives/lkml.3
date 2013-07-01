Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3GAHFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:05:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GAHFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:05:43 -0400
Message-ID: <1372662315.2974.20.camel@cr0>
Subject: Re: [RFC Patch net-next 2/5] net: introduce generic inet_pton()
From: Cong Wang <amwang@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 15:05:15 +0800
In-Reply-To: <20130627145116.03e2f892@nehalam.linuxnetplumber.net>
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>
	 <1372315398-19683-3-git-send-email-amwang@redhat.com>
	 <20130627145116.03e2f892@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 14:51 -0700, Stephen Hemminger wrote:
> >  
> > +static inline int inet_pton(const char *str, union inet_addr *addr)
> > +{
> >
> 
> A couple of comments:
> 1. No reason for this to be inline

Okay, I will move them into net/core/utils.c.

> 2. If function has same name as userspace it must have same arguments
>    and return value. Either:
>     a. rename it to kinet_pton or some other name
>     b. make it work the same.
> 

Makes sense too me, I will try your option b) first, if it is over-kill
I will fall back to option a).

Thanks!


