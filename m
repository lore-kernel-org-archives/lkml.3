Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3HTWxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:53:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab3HTWxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:53:00 -0400
Date: Tue, 20 Aug 2013 18:52:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
cc: Frank Mayhar <fmayhar@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
In-Reply-To: <20130820222439.GA5883@redhat.com>
Message-ID: <alpine.LRH.2.02.1308201852220.22284@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com> <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com> <1377034118.24869.48.camel@bobble.lax.corp.google.com> <alpine.LRH.2.02.1308201745130.8826@file01.intranet.prod.int.rdu2.redhat.com>
 <1377035833.24869.57.camel@bobble.lax.corp.google.com> <20130820222439.GA5883@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Aug 2013, Mike Snitzer wrote:

> Mikulas' point is that you cannot reduce the size to smaller than 1.
> And aside from rq-based DM, 1 is sufficient to allow for forward
> progress even when memory is completely consumed.
> 
> A patch that simply changes them to 1 but makes the rq-based DM
> mempool's size configurable should actually be fine.

Yes, I think it would be viable.

Mikulas

> Mike
