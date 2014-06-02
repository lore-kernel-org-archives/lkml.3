Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaFBJ6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:58:38 -0400
Received: from srv01.voixit.com ([78.47.68.188]:38951 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaFBJ6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:58:36 -0400
Subject: Re: [PATCH RFC - TAKE TWO - 08/12] block, bfq: preserve a low latency also with NCQ-capable drives
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140531134823.GB24557@mtj.dyndns.org>
Date: Mon, 2 Jun 2014 11:58:31 +0200
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9390495C-885D-4C0E-9F4D-70687A1BE9C5@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <1401354343-5527-9-git-send-email-paolo.valente@unimore.it> <20140531134823.GB24557@mtj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 31/mag/2014, alle ore 15:48, Tejun Heo <tj@kernel.org> ha scritto:

> On Thu, May 29, 2014 at 11:05:39AM +0200, Paolo Valente wrote:
>> This patch addresses this issue by not disabling device idling for
> 
> This patch addresses this issue by allowing device idling for...
> 
>> weight-raised queues, even if the device supports NCQ. This allows BFQ
>> to start serving a new queue, and therefore allows the drive to
> 
> This disallows BFQ to start serving a new queue, and therefore the
> drive to prefetch new requests, until the idling timeout expires.
> 
> Prefetch?  Can you elaborate?

By prefetching I meant just queuing more than one request (by the drive). I hope that this clarifies things a little bit.

Paolo

> 
> Thanks.
> 
> -- 
> tejun


--
Paolo Valente                                                 
Algogroup
Dipartimento di Fisica, Informatica e Matematica		
Via Campi, 213/B
41125 Modena - Italy        				  
homepage:  http://algogroup.unimore.it/people/paolo/

