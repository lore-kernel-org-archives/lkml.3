Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaHUOP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:15:58 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:42199 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838AbaHUOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:15:57 -0400
Date: Thu, 21 Aug 2014 09:15:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/sl[ao]b: always track caller in
 kmalloc_(node_)track_caller()
In-Reply-To: <1408608562-20339-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408210915310.32524@gentwo.org>
References: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com> <1408608562-20339-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> >From this change, we can turn on/off CONFIG_DEBUG_SLAB without full
> kernel build and remove some complicated '#if' defintion. It looks
> more benefitial to me.

I agree.

Acked-by: Christoph Lameter <cl@linux.com>

