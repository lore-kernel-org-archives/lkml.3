Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbaKAABG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:01:06 -0400
Received: from roy.gaast.net ([80.101.33.21]:44361 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbaKAABE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:01:04 -0400
Message-ID: <545422A3.5010101@gaast.net>
Date: Sat, 01 Nov 2014 00:00:35 +0000
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <543F049F.5090605@gaast.net> <544EDD40.1040107@gaast.net> <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com> <545027F9.1040703@gaast.net> <CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com> <5450B55E.6010103@gaast.net> <CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com> <545214C5.6070004@gaast.net> <CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com> <5452B3A6.7060100@gaast.net> <CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com> <5452C8BE.3060206@gaast.net> <CAE9FiQWd7wC9ijzgObCcGd9QE+U3_wzjQwafXhV=U61hLxGszg@mail.gmail.com> <CAE9FiQXPZdYndp6rTKxLUkkwX=AQtRVH3JJC=xzQfsehtBgOqA@mail.gmail.com> <545358D5.6070903@gaast.net> <CAE9FiQWeZ4AXwwT=NS96Q+FxPz+3Bj5rf8JoRDmJ-RHBhjj78g@mail.gmail.com> <5453FB8E.8050506@gaast.net> <CAE9FiQX7nhBKBGUm6SkWdA3EUm1MZ3rgWf04+AUPAPgSCNam=w@mail.gmail.com> <CAE9FiQVQK4aa9bW3d3=rw+hgogSFuKnwFSutSqcMrmCCc9_3dw@mail.gmail.com>
In-Reply-To: <CAE9FiQVQK4aa9bW3d3=rw+hgogSFuKnwFSutSqcMrmCCc9_3dw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Patch #1 worked after a simple s/&&/)/. And patch #2 seems to fix the 
problem as well!


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
