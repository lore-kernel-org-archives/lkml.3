Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaIYSi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:38:56 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:50080 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbaIYSiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:38:55 -0400
Date: Thu, 25 Sep 2014 13:38:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: use IS_ENABLED() instead of ZONE_DMA_FLAG
In-Reply-To: <1411667851.2020.6.camel@x41>
Message-ID: <alpine.DEB.2.11.1409251338370.22503@gentwo.org>
References: <1411667851.2020.6.camel@x41>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Paul Bolle wrote:

> The Kconfig symbol ZONE_DMA_FLAG probably predates the introduction of
> IS_ENABLED(). Remove it and replace its two uses with the equivalent
> IS_ENABLED(CONFIG_ZONE_DMA).

Acked-by: Christoph Lameter <cl@linux.com>
