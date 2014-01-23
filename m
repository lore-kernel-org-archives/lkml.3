Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaAWGP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:15:56 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:64087 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaAWGPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:15:55 -0500
Date: Wed, 22 Jan 2014 22:15:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
In-Reply-To: <20140123061343.GB15206@redhat.com>
Message-ID: <alpine.DEB.2.02.1401222214290.8088@chino.kir.corp.google.com>
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com> <20140123061343.GB15206@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Dave Jones wrote:

> It's 10, because I had MAXSMP set.
> 
> So, MAX_NUMNODES = 1 << 10
> 
> And the bitmask is made of longs. 1024 of them.
> 
> How does this work ?
> 

It's 1024 bits.
