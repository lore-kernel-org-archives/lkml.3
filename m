Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaLRO5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:57:44 -0500
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:51127 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbaLRO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:57:43 -0500
Date: Thu, 18 Dec 2014 08:57:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
In-Reply-To: <CAAmzW4Oyw974Zg274C2-1BcOphEJY63gx7v2QTQuULOJBzknig@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412180856400.2593@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141215075933.GD4898@js1304-P5Q-DELUXE> <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com> <alpine.DEB.2.11.1412170935480.2047@gentwo.org>
 <CAAmzW4Oyw974Zg274C2-1BcOphEJY63gx7v2QTQuULOJBzknig@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 18 Dec 2014, Joonsoo Kim wrote:
> > Good idea. How does this affect the !CONFIG_PREEMPT case?
>
> One more this_cpu_xxx makes fastpath slow if !CONFIG_PREEMPT.
> Roughly 3~5%.
>
> We can deal with each cases separately although it looks dirty.

Ok maybe you can come up with a solution that is as clean as possible?
