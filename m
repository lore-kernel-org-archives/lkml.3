Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629Ab3BYT2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 14:28:01 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:3746 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759295Ab3BYT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 14:27:59 -0500
Date: Mon, 25 Feb 2013 19:27:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Rik van Riel <riel@redhat.com>, Aaron Tomlin <atomlin@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        glommer@parallels.com
Subject: Re: [PATCH v2] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
In-Reply-To: <512BA33C.6060506@redhat.com>
Message-ID: <0000013d12d36816-5dd04154-a1ab-4a0e-977d-9690c597f12e-000000@email.amazonses.com>
References: <591256534.8212978.1361812690861.JavaMail.root@redhat.com> <512BA33C.6060506@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, Rik van Riel wrote:

> On 02/25/2013 12:18 PM, Aaron Tomlin wrote:
>
> > mm: slab: Verify the nodeid passed to ____cache_alloc_node
> >
> > If the nodeid is > num_online_nodes() this can cause an
> > Oops and a panic(). The purpose of this patch is to assert
> > if this condition is true to aid debugging efforts rather
> > than some random NULL pointer dereference or page fault.
> >
> > Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
>
> Reviewed-by: Rik van Riel <riel@redhat.com>

It may be helpful to cc the slab maintainers...
