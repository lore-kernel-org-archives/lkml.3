Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaLJJLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:11:06 -0500
Received: from ozlabs.org ([103.22.144.67]:32983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaLJJLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:11:03 -0500
Message-ID: <1418202661.9279.1.camel@ellerman.id.au>
Subject: Re: [PATCH 2/2] perf/power/hv-24x7: Use kmem_cache_free() instead
 of kfree
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, dev@codyps.com, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Date: Wed, 10 Dec 2014 20:11:01 +1100
In-Reply-To: <20141210070917.GB27377@us.ibm.com>
References: <20141210070637.GA27377@us.ibm.com>
	 <20141210070917.GB27377@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 23:09 -0800, Sukadev Bhattiprolu wrote:
> From 982bf5a660ae33fbe2f9187187caa6752c66783d Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 10 Dec 2014 01:43:34 -0500
> Subject: [PATCH 2/2] power/perf: hv-24x7: Use kmem_cache_free() instead of
>  kfree

This got a bit munged, ...

> Use kmem_cache_free() to free a buffer allocated with kmem_cache_alloc().
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> p#	set2.log

.. and here too.

I can fix it up this time.

cheers


