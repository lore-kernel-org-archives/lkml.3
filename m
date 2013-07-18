Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3GRKeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:34:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36509 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GRKeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
References: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
Date: Thu, 18 Jul 2013 13:34:04 +0300
Message-ID: <CAFub=KQJu-kD1_oA6=2y7svwixvFTc-g_D3aMkwuARfFx6H4RQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] distinct load average per-cpuset
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 10:05 PM, Andrea Righi <andrea@betterlinux.com> wrote:
> Overview
> ~~~~~~~~
> The cpusets subsystem allows to assign a different set of CPUs to a cgroup. A
> typical use case is to split large systems in small CPU/memory partitions and
> isolate certain users/applications in these subsets of the system.
>
> Sometimes, to have a quick overview of the state of each partition, we may be
> interested to get the load average of the CPUs assigned to a particular cpuset,
> rather than the global load average of the system.
>
> Proposed solution
> ~~~~~~~~~~~~~~~~~
> The proposal is to add a new file in the cpuset subsystem to report the load
> average of the CPUs assinged to a particular cpuset cgroup.

Hi,

What is the situation with this patch?


--
Ozan Çağlayan
Research Assistant
Galatasaray University - Computer Engineering Dept.
http://www.ozancaglayan.com
