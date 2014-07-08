Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaGHWrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:47:23 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46507 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGHWrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140708223506.GG4603@linux.vnet.ibm.com>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-6-git-send-email-bobby.prani@gmail.com> <20140611214752.GC16940@cloud>
 <20140708223506.GG4603@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 8 Jul 2014 18:46:50 -0400
Message-ID: <CAJhHMCAkpFh+cpQA1R6Ar41K7GHgPKMMCs9DAqxMu0vJvHw3EA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/5] kernel/rcu/rcutorture.c:185 fix a sparse warning
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 6:35 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Jun 11, 2014 at 02:47:52PM -0700, josh@joshtriplett.org wrote:
>> On Wed, Jun 11, 2014 at 04:39:43PM -0400, Pranith Kumar wrote:
>> > fix the following sparse warning
>> >
>> > kernel/rcu/rcutorture.c:185:1: warning: symbol 'boost_mutex' was not declared. Should it be static?
>> >
>> > by marking boost_mutex as a static mutex
>> >
>> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>
>> Please preserve the comment alignment (by deleting a tab).  With that
>> fixed:
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> Queued for 3.18.
>
> But Pranith, next time Josh gives you a review comment, could you please
> respond with the appropriate update?
>

I was away from my work desktop for the past few days. I actually sent
a fixed patch 10 min ago, but in a new series.

Sorry for missing this, I will drop an update promptly next time.


-- 
Pranith
