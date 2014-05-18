Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaERSDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 14:03:18 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:1649 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaERSDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 14:03:17 -0400
Message-ID: <1400436183.9463.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: Fix semctl(,,{GETNCNT,GETZCNT})
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Date: Sun, 18 May 2014 11:03:03 -0700
In-Reply-To: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

On Sun, 2014-05-18 at 09:58 +0200, Manfred Spraul wrote:
> Hi Andrew,
> 
> I've applied the changes recommended by Michael and Davidlohr - and I don't 
> have any open points on my list, either.

Please keep the review/ack tags that are collected upon different
versions of the patchset.

Thanks,
Davidlohr

