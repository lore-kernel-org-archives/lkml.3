Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaEIDap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:30:45 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:39606 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaEIDao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:30:44 -0400
Message-ID: <1399606230.2497.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH V2] MM: make vmpressure_win dynamic
From: Davidlohr Bueso <davidlohr@hp.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Thu, 08 May 2014 20:30:30 -0700
In-Reply-To: <20140507225206.ea7cff02caf1118bb4b5a48d@skynet.be>
References: <20140507225206.ea7cff02caf1118bb4b5a48d@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 22:52 +0200, Fabian Frederick wrote:
> Initialize vmpressure_win in vmstat using
> calculate_normal_threshold() based on each zone/cpu * SWAP_CLUSTER_SIZE
> 
> Value refreshed through cpu notifier and exposed in read-only through /sys/kernel

You need to describe the problem, with a proper changelog. What are you
trying to achieve/solve here?

> This is untested.

Hmm, why? It seems perfectly testable.

Thanks,
Davidlohr

