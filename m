Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaGQDL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:11:26 -0400
Received: from wolff.to ([98.103.208.27]:46363 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750994AbaGQDLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:11:24 -0400
Date: Wed, 16 Jul 2014 22:09:47 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717030947.GA17889@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <53C7084C.7090104@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Thu, Jul 17, 2014 at 01:18:36 +0200,
  Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>So the output of
>
>$ cat /proc/sys/kernel/sched_domain/cpu*/domain*/*
>
>would be handy too.

Attached and added to the bug.

>Just to make sure, you do have 'CONFIG_X86_32=y' and '# CONFIG_NUMA is 
>not set' in your build?

Yes.

I probably won't be able to get /proc/schedstat on my next test since the 
system will probably crash right away. However, I probably will have a 
much faster rebuild and might still be able to get the info for you 
before I leave tomorrow.

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sched_domain.out"

32
0
0
687
0
0
110
4
28353
2
SMT
0
0
32
2
1
4143
0
1
125
8
15370
4
DIE
0
0
32
0
0
687
0
0
110
4
21753
2
SMT
0
0
32
2
1
4143
0
1
125
8
12715
4
DIE
0
0
32
0
0
687
0
0
110
4
25097
2
SMT
0
0
32
2
1
4143
0
1
125
8
21624
4
DIE
0
0
32
0
0
687
0
0
110
4
23714
2
SMT
0
0
32
2
1
4143
0
1
125
8
14920
4
DIE
0
0

--dDRMvlgZJXvWKvBx--
