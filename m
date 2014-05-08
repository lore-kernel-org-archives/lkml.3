Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaEHNyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:54:16 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:48331 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaEHNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:54:13 -0400
Date: Thu, 8 May 2014 08:54:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v2] mm, slab: suppress out of memory warning unless debug
 is enabled
In-Reply-To: <alpine.DEB.2.02.1405071500030.25024@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1405080853421.22626@gentwo.org>
References: <alpine.DEB.2.02.1405071418410.8389@chino.kir.corp.google.com> <20140507142925.b0e31514d4cd8d5857b10850@linux-foundation.org> <alpine.DEB.2.02.1405071431580.8454@chino.kir.corp.google.com> <20140507144858.9aee4e420908ccf9334dfdf2@linux-foundation.org>
 <alpine.DEB.2.02.1405071500030.25024@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, David Rientjes wrote:

> Suppress this out of memory warning if the allocator is configured without debug
> supported.  The page allocation failure warning will indicate it is a failed
> slab allocation, the order, and the gfp mask, so this is only useful to diagnose
> allocator issues.

Acked-by: Christoph Lameter <cl@linux.com>

