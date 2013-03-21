Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3CUVuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:50:14 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40913 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3CUVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:50:12 -0400
Message-ID: <1363902605.4488.33.camel@thor.lan>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Peter Hurley <peter@hurleysoftware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>
Date: Thu, 21 Mar 2013 17:50:05 -0400
In-Reply-To: <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 14:10 -0700, Andrew Morton wrote:
> On Wed, 20 Mar 2013 15:55:30 -0400 Rik van Riel <riel@surriel.com> wrote:
> 
> > This series makes the sysv semaphore code more scalable,
> > by reducing the time the semaphore lock is held, and making
> > the locking more scalable for semaphore arrays with multiple
> > semaphores.
> > 
> > The first four patches were written by Davidlohr Buesso, and
> > reduce the hold time of the semaphore lock.
> > 
> > The last three patches change the sysv semaphore code locking
> > to be more fine grained, providing a performance boost when
> > multiple semaphores in a semaphore array are being manipulated
> > simultaneously.
> 
> These patches conflict pretty badly with Peter's:

On one point I'm a little confused: my series has been in linux-next for
a while. On what tree is this series based?


