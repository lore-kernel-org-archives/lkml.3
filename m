Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaEMAEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:04:34 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:12669 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaEMAEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:04:33 -0400
Message-ID: <1399939470.2648.38.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/6] ipc/sem.c: Change perform_atomic_semop parameters
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Date: Mon, 12 May 2014 17:04:30 -0700
In-Reply-To: <1399716199-26776-5-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-4-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-5-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
> Right now, perform_atomic_semop gets the content of sem_queue as individual
> fields.
> Changes that, instead pass a pointer to sem_queue.
> 
> This is a preparation for the next patch: it uses
> sem_queue to store the reason why a task must sleep.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

