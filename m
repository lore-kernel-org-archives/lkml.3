Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaFMQyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:54:16 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48718 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbaFMQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:54:14 -0400
Date: Fri, 13 Jun 2014 11:54:11 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v3 7/8] slub: make dead memcg caches discard free
 slabs immediately
In-Reply-To: <d4608a7a00080a51740d747703af5462f1255176.1402602126.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1406131153520.913@gentwo.org>
References: <cover.1402602126.git.vdavydov@parallels.com> <d4608a7a00080a51740d747703af5462f1255176.1402602126.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Vladimir Davydov wrote:

> Since a dead memcg cache is destroyed only after the last slab allocated
> to it is freed, we must disable caching of empty slabs for such caches,
> otherwise they will be hanging around forever.

Looks good and clean.

Acked-by: Christoph Lameter <cl@linux.com>
