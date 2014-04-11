Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbaDKA1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:27:40 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:16065 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901AbaDKA1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:27:34 -0400
Message-ID: <1397176053.2541.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Possible issue with commit 6f008e72cd - locking/mutex: Fix
 debug checks.
From: Davidlohr Bueso <davidlohr@hp.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 17:27:33 -0700
In-Reply-To: <3817.1397172208@turing-police.cc.vt.edu>
References: <3817.1397172208@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 19:23 -0400, Valdis Kletnieks wrote:
> So recent linux-next lock up on my laptop due to a third-party module.
> Bisection finds this as the source of the issue:
> 
> 6f008e72cd111a119b5d8de8c5438d892aae99eb is the first bad commit

This was already reported, please refer to this thread:
https://lkml.org/lkml/2014/4/6/1

