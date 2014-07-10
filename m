Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaGJOIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:08:45 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:34221 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbaGJOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:08:43 -0400
Date: Thu, 10 Jul 2014 09:08:40 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 12/21] mm: util: move krealloc/kzfree
 to slab_common.c
In-Reply-To: <53BE4412.6030707@samsung.com>
Message-ID: <alpine.DEB.2.11.1407100908090.12483@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1404905415-9046-13-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.11.1407090931350.1384@gentwo.org> <53BE4412.6030707@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Andrey Ryabinin wrote:

> Should I send another patch to move this to slab_common.c?

Send one patch that is separte from this patchset to all slab
maintainers and include my ack.

