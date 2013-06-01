Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab3FAKF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:05:28 -0400
Received: from mout.gmx.net ([212.227.17.20]:61375 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684Ab3FAKFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:05:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19YuJxEv55YbOnVY5F5BX9BF9pHpFfR11aL2xvZ+t
	euBLmijIFcs5YK
Message-ID: <1370081116.7268.7.camel@marge.simpson.net>
Subject: Re: [PATCH 2/4] ipc/sem: seperate wait-for-zero and alter tasks
 into seperate queues
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 01 Jun 2013 12:05:16 +0200
In-Reply-To: <1370080999.7268.5.camel@marge.simpson.net>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
	 <1369559335-13491-3-git-send-email-manfred@colorfullife.com>
	 <51A39E71.70900@redhat.com> <51A9BCDA.9040006@colorfullife.com>
	 <1370080999.7268.5.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 12:03 +0200, Mike Galbraith wrote:

> -rtm is with our patches added, -rt is backport without.

'y' key in 'your' not fully depressed.

