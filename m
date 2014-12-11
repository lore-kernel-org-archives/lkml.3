Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbaLKPBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:01:05 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:57606 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaLKPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:01:04 -0500
Date: Thu, 11 Dec 2014 09:01:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>, akpm <akpm@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
In-Reply-To: <20141211141938.6420b94a@redhat.com>
Message-ID: <alpine.DEB.2.11.1412110900370.28416@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141210163033.717707217@linux.com> <CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com> <alpine.DEB.2.11.1412101107350.6291@gentwo.org> <CAOJsxLH4BGT9rGgg_4nxUMgW3sdEzLrmX2WtM8Ld3aytdR5e8g@mail.gmail.com>
 <alpine.DEB.2.11.1412101136520.6639@gentwo.org> <20141211141938.6420b94a@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Jesper Dangaard Brouer wrote:

> If I explicitly add "inline", then it gets inlined, and performance is good again.

Ok adding inline for the next release.

