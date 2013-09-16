Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3IPLDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:03:30 -0400
Received: from mout.gmx.net ([212.227.15.18]:51527 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3IPLD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:03:29 -0400
Message-ID: <1379329403.5510.60.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] ipc/sem.c: Race in sem_lock()
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com
Date: Mon, 16 Sep 2013 13:03:23 +0200
In-Reply-To: <1379232411.5545.183.camel@marge.simpson.net>
References: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
	 <1379225343.5545.154.camel@marge.simpson.net>
	 <1379232411.5545.183.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:I2xSCKdQA1V+fWye/phvVpR2Tb8my8CC0ZjtKl80jbhkamt2wv2
 /eF2qR781yredQemkiXiJ/Z+EPT77srr6rgP0ijlZaZQ8ufGqOhkNYhZcGicEfKnYjpc5Gj
 2RVuIlpVTRg2f8sPMzGeRPWfI8t9cdx+SvfirHw49jypf8MZtUxRDfNtLe9p3CdPuGNu7rt
 NdICp0Agf43KFBe3V7QLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-15 at 10:06 +0200, Mike Galbraith wrote:

> master:  Cpus 64, interleave 1 delay 0: 10039494796 in 30 secs

plus patches
  master:  Cpus 64, interleave 1 delay 0:  9139925137 in 30 secs

> 3.10.10: Cpus 64, interleave 1 delay 0:   129236313 in 30 secs

