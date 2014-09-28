Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaI1Qiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:38:55 -0400
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:49162 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbaI1Qiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:38:54 -0400
Date: Sun, 28 Sep 2014 11:38:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jeremiah Mahler <jmmahler@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [PATCH 1/3] mm/slab: use percpu allocator for cpu
 cache
In-Reply-To: <20140928062449.GA1277@hudson.localdomain>
Message-ID: <alpine.DEB.2.11.1409281136390.10322@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com> <20140928062449.GA1277@hudson.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2014, Jeremiah Mahler wrote:

> I just encountered a problem on a Lenovo Carbon X1 where it will
> suspend but won't resume.  A bisect indicated that this patch
> is causing the problem.

Could you please not quote the whole patch. Took me a while to find what
you were saying.

> 997888488ef92da365b870247de773255227ce1f
>
> I imagine the patch author, Joonsoo Kim, might have a better idea
> why this is happening than I do.  But if I can provide any information
> or run any tests that might be of help just let me know.

Could you provide more details? Any messages when the system is trying to
resume?

