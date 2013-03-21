Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab3CUW5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:57:03 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51493 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3CUW5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:57:01 -0400
Message-ID: <1363906618.4431.37.camel@edumazet-glaptop>
Subject: Re: +
 atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive .patch
 added to -mm tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 15:56:58 -0700
In-Reply-To: <20130321183021.GA27586@redhat.com>
References: <20130314162413.GA21344@redhat.com>
	 <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
	 <20130315134632.GA18335@redhat.com>
	 <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
	 <20130315165131.GA32065@redhat.com>
	 <20130317172621.GQ3656@linux.vnet.ibm.com>
	 <20130321170827.GA23539@redhat.com>
	 <1363889025.4431.35.camel@edumazet-glaptop>
	 <20130321183021.GA27586@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 19:30 +0100, Oleg Nesterov wrote:

> To me, it would be better to kill atomic_inc_not_zero_hint() or unify
> unify it with atomic_inc_not_zero(). But this is another story.

git is your friend.

I suggest you read 3f9d35b9514 changelog before killing it, thanks.



