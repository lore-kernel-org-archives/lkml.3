Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3CVBOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:14:21 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6967 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3CVBOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:14:20 -0400
Message-ID: <1363914858.31240.60.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/7] ipc,sem: open code and rename sem_lock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@redhat.com>
Date: Thu, 21 Mar 2013 18:14:18 -0700
In-Reply-To: <1363809337-29718-6-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <1363809337-29718-6-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:55 -0400, Rik van Riel wrote:
> Rename sem_lock to sem_obtain_lock, so we can introduce a sem_lock
> function later that only locks the sem_array and does nothing else.
> 
> Open code the locking from ipc_lock in sem_obtain_lock, so we can
> introduce finer grained locking for the sem_array in the next patch.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>


