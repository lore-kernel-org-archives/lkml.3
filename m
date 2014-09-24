Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaIXID7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:03:59 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:56199 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbaIXICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:02:17 -0400
Message-ID: <1411545734.30630.4.camel@linux-t7sj.site>
Subject: Re: [PATCH 0/4] ipc/shm.c: increase the limits for SHMMAX, SHMALL
From: Davidlohr Bueso <dave@stgolabs.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Wed, 24 Sep 2014 10:02:14 +0200
In-Reply-To: <54210407.1000602@gmail.com>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
	 <CAKgNAkjuU68hgyMOVGBVoBTOhhGdBytQh6H0ExiLoXfujKyP_w@mail.gmail.com>
	 <1401823560.4911.2.camel@buesod1.americas.hpqcorp.net>
	 <54210407.1000602@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 07:24 +0200, Michael Kerrisk (man-pages) wrote:
> David,
> 
> I applied various pieces from your patch on top of material
> that I already had, so that now we have the text below describing
> these limits.  Comments/suggestions/improvements from all welcome.

Looks good, thanks!

