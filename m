Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3DVIzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:55:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:56650 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3DVIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:55:22 -0400
Message-ID: <5174FAF5.80503@linutronix.de>
Date: Mon, 22 Apr 2013 10:55:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8.4-rt2
References: <20130326201722.GA14220@linutronix.de> <CAP=VYLoXfECaSBuvYdZ3qbsnR9QMYpoRnKGZdY=P6zS_TYOcCA@mail.gmail.com> <20130408183012.GA5778@linutronix.de> <CAONaPpFSf+Eh3K3BHCsPTQdxmbghHhtH=wMooh+Ers2QiCdH=g@mail.gmail.com>
In-Reply-To: <CAONaPpFSf+Eh3K3BHCsPTQdxmbghHhtH=wMooh+Ers2QiCdH=g@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 06:25 PM, John Kacur wrote:
> Where did you fix these up? Can we have access?

I don't see reason why not. I just pushed my quilt queue to
 git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/rt-v3.8-devel.git

Remember it is not a kernel tree, it is a quilt queue.

> Thanks
> 
> John

Sebastian
