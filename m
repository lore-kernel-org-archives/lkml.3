Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaHMOJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:09:50 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56103 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaHMOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:09:49 -0400
Message-ID: <1407938985.5542.75.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Date: Wed, 13 Aug 2014 16:09:45 +0200
In-Reply-To: <20140813133934.GM9918@twins.programming.kicks-ass.net>
References: <20140812142539.01851e52@annuminas.surriel.com>
	 <20140812191218.GA15210@redhat.com>
	 <1407913190.5542.50.camel@marge.simpson.net>
	 <20140813111112.GJ9918@twins.programming.kicks-ass.net>
	 <53EB66F6.2050304@redhat.com>
	 <20140813133934.GM9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-13 at 15:39 +0200, Peter Zijlstra wrote:

> PROCESS_CPUTIME doesn't need tasklist lock;.

Oops, sorry, didn't notice that that had changed.

(not that it looks less painful, just different flavor of agony)

-Mike

