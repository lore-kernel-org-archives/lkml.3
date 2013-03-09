Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3CITNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 14:13:35 -0500
Received: from mail.renton.name ([90.155.165.44]:39347 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3CITNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 14:13:33 -0500
Date: Sat, 9 Mar 2013 23:11:58 +0400
From: Alexey Vlasov <renton@renton.name>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
Message-ID: <20130309191158.GD6115@beaver>
References: <20130209141029.GA13493@beaver>
 <1360422473.6696.28.camel@edumazet-glaptop>
 <20130307125424.GI13493@beaver>
 <1362673223.15793.215.camel@edumazet-glaptop>
 <20130307163743.GC6115@beaver>
 <1362675448.15793.216.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362675448.15793.216.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:57:28AM -0800, Eric Dumazet wrote:
> 
> Well, remove all alien patches and try to reproduce the bug with a
> pristine linux kernel.

I wrote to Spender (developer grsec) and he confirmed that it's possible
that a problem is with grsec patch.

Thank you greatly for your answers!

-- 
BRGDS. Alexey Vlasov.
