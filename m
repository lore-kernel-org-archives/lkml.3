Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbaLKPD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:03:28 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:41132 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbaLKPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:03:27 -0500
Date: Thu, 11 Dec 2014 09:03:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo.kim@lge.com
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
In-Reply-To: <20141211143518.02c781ee@redhat.com>
Message-ID: <alpine.DEB.2.11.1412110902450.28416@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141211143518.02c781ee@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Jesper Dangaard Brouer wrote:

> It looks like an impressive saving 116 -> 60 cycles.  I just don't see
> the same kind of improvements with my similar tests[1][2].

This is particularly for a CONFIG_PREEMPT kernel. There will be no effect
on !CONFIG_PREEMPT I hope.

> I do see the improvement, but it is not as high as I would have expected.

Do you have CONFIG_PREEMPT set?

