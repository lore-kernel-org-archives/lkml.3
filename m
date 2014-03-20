Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaCTCXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:23:34 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51030 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaCTCXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:23:32 -0400
Message-ID: <1395282203.11039.24.camel@marge.simpson.net>
Subject: Re: Thread Scheduler
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Jack Carrozzo <jack@crepinc.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 20 Mar 2014 03:23:23 +0100
In-Reply-To: <1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com>
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
	 <1395228430.4896.6.camel@marge.simpson.net>
	 <1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>
	 <CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>
	 <1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 13:01 -0700, Mahmood Naderan wrote:
> 
> One more question. Is it possible to dynamically change the scheduling
> policy, e.g from fair to clock?

marge:~ # man -k setscheduler getscheduler
sched_setscheduler (2) - set and get scheduling policy/parameters
sched_setscheduler (3p) - set scheduling policy and parameters (REALTIME)
sched_getscheduler (2) - set and get scheduling policy/parameters
sched_getscheduler (3p) - get scheduling policy (REALTIME)

