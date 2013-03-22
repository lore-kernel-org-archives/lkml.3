Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab3CVBOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:14:42 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:25274 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3CVBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:14:41 -0400
Message-ID: <1363914874.31240.61.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 6/7] ipc,sem: have only one list in struct sem_queue
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@redhat.com>
Date: Thu, 21 Mar 2013 18:14:34 -0700
In-Reply-To: <1363809337-29718-7-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <1363809337-29718-7-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:55 -0400, Rik van Riel wrote:
> Having only one list in struct sem_queue, and only queueing simple
> semaphore operations on the list for the semaphore involved, allows
> us to introduce finer grained locking for semtimedop.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>


