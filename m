Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3LCVOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:14:14 -0500
Received: from a9-111.smtp-out.amazonses.com ([54.240.9.111]:39159 "EHLO
	a9-111.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab3LCVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:14:10 -0500
X-Greylist: delayed 862 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 16:14:10 EST
Date: Tue, 3 Dec 2013 20:59:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Meelis Roos <mroos@linux.ee>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: Slab BUG with DEBUG_* options
In-Reply-To: <alpine.SOC.1.00.1312032232210.25191@math.ut.ee>
Message-ID: <00000142ba4274a7-5ff9996c-6ce6-412e-9a06-37b12b501ddb-000000@email.amazonses.com>
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee> <00000142b923d9de-2c71e0b6-7443-46c0-bbde-93a81b50ed37-000000@email.amazonses.com> <alpine.SOC.1.00.1312032232210.25191@math.ut.ee>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.03-54.240.9.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Meelis Roos wrote:

> Kernel panic - not syncing: Creation of kmalloc slab (null) size=8388608
> failed. Reason -7

Same here.

