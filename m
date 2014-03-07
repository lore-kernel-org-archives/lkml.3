Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaCGROS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:14:18 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:51751 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaCGROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:14:17 -0500
Date: Fri, 7 Mar 2014 11:14:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Jones <davej@redhat.com>
cc: Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        penberg@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: slub: fix leak of 'name' in sysfs_slab_add
In-Reply-To: <20140307153259.GA778@redhat.com>
Message-ID: <alpine.DEB.2.10.1403071113590.21846@nuc>
References: <20140306211141.GA17009@redhat.com> <5319649C.3060309@parallels.com> <20140307153259.GA778@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014, Dave Jones wrote:

>  > Since this function was modified in the mmotm tree, I would propose
>  > something like this on top of mmotm to avoid further merge conflicts:
>
> Looks good to me.

Acked-by: Christoph Lameter <cl@linux.com>

