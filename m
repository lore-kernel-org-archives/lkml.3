Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaJ0TVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:21:35 -0400
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:44339 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbaJ0TVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:21:34 -0400
Date: Mon, 27 Oct 2014 14:21:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Oleg Nesterov <oleg@redhat.com>
cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 2/3] introduce probe_slab_address()
In-Reply-To: <20141027195425.GC11736@redhat.com>
Message-ID: <alpine.DEB.2.11.1410271420580.19427@gentwo.org>
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com> <20141027195425.GC11736@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Oleg Nesterov wrote:

> Extract the ifdef(CONFIG_DEBUG_PAGEALLOC) code from get_freepointer_safe()
> into the new generic helper, probe_slab_address(). The next patch will add
> another user.

Acked-by: Christoph Lameter <cl@linux.com>
