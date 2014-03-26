Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaCZSwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:52:35 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:64082 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZSwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140326.144613.1346051389108269225.davem@davemloft.net>
References: <1395806210-23528-1-git-send-email-sj38.park@gmail.com>
 <1395828547.22808.28.camel@kazak.uk.xensource.com> <CAEjAshoYWeCdVD9mC4f6EQkQkd-dVuk47gGEZ-4ig-uVS938ag@mail.gmail.com>
 <20140326.144613.1346051389108269225.davem@davemloft.net>
From: SeongJae Park <sj38.park@gmail.com>
Date: Thu, 27 Mar 2014 03:51:56 +0900
Message-ID: <CAEjAshoKmsbsUBJ-EzfaXwncNaxtsJCM+p_h92t3SZ+FAHEKsA@mail.gmail.com>
Subject: Re: [PATCH] ixen-netback: fix trivial printf format build warning
To: David Miller <davem@davemloft.net>
Cc: Ian.Campbell@citrix.com, trivial@kernel.org, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 3:46 AM, David Miller <davem@davemloft.net> wrote:
> From: SeongJae Park <sj38.park@gmail.com>
> Date: Wed, 26 Mar 2014 19:34:21 +0900
>
>> Thank you for let me know kindly :)
>
> Also your fix wasn't correct.
>
> You changed the code to use %lx but the type isn't a long.
>
> It's the difference between two pointers, which is ptrdiff_t.  The
> proper printf format string for a hexadecimal ptrdiff_t is %tx

You're right. Thanks for pointing that.
