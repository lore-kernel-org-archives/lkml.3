Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3AWPZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:25:23 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:35327 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584Ab3AWPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:25:21 -0500
Date: Wed, 23 Jan 2013 15:25:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] slub: correct to calculate num of acquired objects
 in get_partial_node()
In-Reply-To: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013c68036988-0c4473ce-1dc9-4967-b321-551196dc2830-000000@email.amazonses.com>
References: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Joonsoo Kim wrote:

> v2: calculate nr of objects using new.objects and new.inuse.
> It is more accurate way than before.

Acked-by: Christoph Lameter <cl@linux.com>
