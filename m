Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3BXAfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 19:35:25 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:1493 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab3BXAfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 19:35:24 -0500
Date: Sun, 24 Feb 2013 00:35:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
In-Reply-To: <CAAmzW4OG6b+7t2S3PUY710CDHkbSb9BWxzxWULm5EzJP4BGEXA@mail.gmail.com>
Message-ID: <0000013d09a01f03-376fad0e-700d-4a04-8da2-89e6b3a22408-000000@email.amazonses.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.02.1302221034380.7600@gentwo.org> <alpine.DEB.2.02.1302221057430.7600@gentwo.org> <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
 <5127A607.3040603@parallels.com> <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com> <CAAmzW4OG6b+7t2S3PUY710CDHkbSb9BWxzxWULm5EzJP4BGEXA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2013, JoonSoo Kim wrote:

> With flushing, deactivate_slab() occur and it has some overhead to
> deactivate objects.
> If my patch properly fix this situation, it is better to use mine
> which has no overhead.

Well this occurs during boot and its not that performance critical.

