Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaIZPxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:53:18 -0400
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:34480 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbaIZPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:53:16 -0400
Date: Fri, 26 Sep 2014 10:53:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] cpuset: simplify cpuset_node_allowed API
In-Reply-To: <ad9b25d464c2050aa2b5016db8eadcc7a6859967.1411741632.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1409261052490.3870@gentwo.org>
References: <cover.1411741632.git.vdavydov@parallels.com> <ad9b25d464c2050aa2b5016db8eadcc7a6859967.1411741632.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Vladimir Davydov wrote:

> So let's simplify the API back to the single check.

Acked-by: Christoph Lameter <cl@linux.com>
