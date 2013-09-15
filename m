Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3IOIHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 04:07:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:63300 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab3IOIHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 04:07:02 -0400
Message-ID: <1379232411.5545.183.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] ipc/sem.c: Race in sem_lock()
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com
Date: Sun, 15 Sep 2013 10:06:51 +0200
In-Reply-To: <1379225343.5545.154.camel@marge.simpson.net>
References: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
	 <1379225343.5545.154.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:Cv1tH0XT5CVaH2eF5HkV0NoNeXjIO/W7U+YVEA0yJlzeTW7Y5dr
 5iZyKFmJvByhKNohwOH4dir1oofITqqbG6oew65pdwAapmo91S1KivPbH1++wmHAVFFKLAs
 89/876oeu+9JX7DGf7CGp8rnxiAnIxxg45fwrn/nDQdJmmX8hqAa93G+APXw72PrzMNwuia
 TtiHAuELTA/+4vOvKxjDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-15 at 08:09 +0200, Mike Galbraith wrote:

> Humongous improvements...

(a couple sem-waitzero numbers)

master:  Cpus 64, interleave 1 delay 0: 10039494796 in 30 secs
3.10.10: Cpus 64, interleave 1 delay 0:   129236313 in 30 secs

(rapidly scrolling micro-font bench vs reality disclaimer)

