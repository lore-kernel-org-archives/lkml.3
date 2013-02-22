Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab3BVRAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:00:12 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:59008 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757664Ab3BVRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:00:10 -0500
Date: Fri, 22 Feb 2013 17:00:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
In-Reply-To: <alpine.DEB.2.02.1302221034380.7600@gentwo.org>
Message-ID: <0000013d02d8ff60-45eb2a10-d2fd-4011-b849-0e51aeb47f79-000000@email.amazonses.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.02.1302221034380.7600@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier fix to this is available here:

https://patchwork.kernel.org/patch/1975301/

and

https://lkml.org/lkml/2013/1/15/55

