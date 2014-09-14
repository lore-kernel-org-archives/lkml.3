Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaINJze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:55:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:42003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaINJzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:55:32 -0400
Date: Sun, 14 Sep 2014 11:55:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task
 is not running
Message-ID: <20140914095528.GU346@worktop.programming.kicks-ass.net>
References: <1410519814.3569.7.camel@tkhai>
 <20140914091338.GN346@worktop.programming.kicks-ass.net>
 <54155DE0.7040606@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54155DE0.7040606@yandex.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 01:20:32PM +0400, Kirill Tkhai wrote:
> On 14.09.2014 13:13, Peter Zijlstra wrote:
> Peter, haven't I moved the sequence from __migrate_task??
> 
> Rechecked again; yes, patch makes __migrate_task using new move_queued_task.

Yes you have ... urgh.. that's what you get for traveling 9 timezones
and trying to do 'work' at 3 am which is really noon.

Lemme try and get my head on straight and have another look.
