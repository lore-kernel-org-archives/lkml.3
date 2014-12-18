Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaLRPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:08:24 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38102 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLRPIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412180856400.2593@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141215075933.GD4898@js1304-P5Q-DELUXE>
	<CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
	<alpine.DEB.2.11.1412170935480.2047@gentwo.org>
	<CAAmzW4Oyw974Zg274C2-1BcOphEJY63gx7v2QTQuULOJBzknig@mail.gmail.com>
	<alpine.DEB.2.11.1412180856400.2593@gentwo.org>
Date: Fri, 19 Dec 2014 00:08:21 +0900
Message-ID: <CAAmzW4PicQ-MaFqpCGj-FN3vx4UeMY+VF_0UrF8+2_B_8kz_bQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
From: Joonsoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-18 23:57 GMT+09:00 Christoph Lameter <cl@linux.com>:
>
> On Thu, 18 Dec 2014, Joonsoo Kim wrote:
>> > Good idea. How does this affect the !CONFIG_PREEMPT case?
>>
>> One more this_cpu_xxx makes fastpath slow if !CONFIG_PREEMPT.
>> Roughly 3~5%.
>>
>> We can deal with each cases separately although it looks dirty.
>
> Ok maybe you can come up with a solution that is as clean as possible?

Okay. Will do!

Thanks.
