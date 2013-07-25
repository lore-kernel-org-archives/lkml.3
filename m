Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3GYLGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:06:07 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:52785 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3GYLGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:06:04 -0400
Message-ID: <1374750359.23313.17.camel@edumazet-glaptop>
Subject: Re: Hack bench regression with CONFIG_SLUB_CPU_PARTIAL disabled
 (info only)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Gao feng <gaofeng@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 04:05:59 -0700
In-Reply-To: <51F0DB11.2080508@linux.vnet.ibm.com>
References: <51F0DB11.2080508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 13:30 +0530, Raghavendra K T wrote:
> Hi,
> 
> While testing hackbench with 3.11-rc1 I observed hackbench testcase
> took too long to complete (32 vcpu kvm guest on 32 core HT off machine).
> 
> hackbench 1x degraded by 3 time (40sec vs 112sec)
> hackbench 2x degraded by around 20time (90sec vs 1800 sec)
> 
> When I bisected, I found that I had CONFIG_SLUB_CPU_PARTIAL
> accidentally disabled.
> I understand that  CONFIG_SLUB_CPU_PARTIAL=y by default and the config
> option is to provide determinism for RT kernels and thus it is not a
> problem.
> But thought of sharing this here so that if somebody runs into same 
> issue accidently, it would save their time.

Incidentally, what difference do you currently get with SLUB and SLAB ?



