Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab3B0Qjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:39:49 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:9130 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab3B0Qjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:39:47 -0500
Date: Wed, 27 Feb 2013 16:39:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
In-Reply-To: <512E0E53.9010908@parallels.com>
Message-ID: <0000013d1c86259f-7383724d-ebf2-4c69-a0a6-10c1bcfec55d-000000@email.amazonses.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.02.1302221034380.7600@gentwo.org> <alpine.DEB.2.02.1302221057430.7600@gentwo.org> <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
 <5127A607.3040603@parallels.com> <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com> <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg@mail.gmail.com> <512E0E53.9010908@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Glauber Costa wrote:

> You can apply this one as-is with Christoph's ACK.

Right.
