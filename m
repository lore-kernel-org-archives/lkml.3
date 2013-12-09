Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384Ab3LIWaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:30:17 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:63264 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3LIWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:30:13 -0500
Date: Mon, 9 Dec 2013 14:30:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Con Kolivas <kernel@kolivas.org>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] BFS CPU scheduler v0.444 for linux-3.12
In-Reply-To: <10123265.xdzIJ6I9nc@hex>
Message-ID: <alpine.DEB.2.02.1312091427370.17848@chino.kir.corp.google.com>
References: <10123265.xdzIJ6I9nc@hex>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Con Kolivas wrote:

> This is to announce a resync and minor update of the Brain Fuck Scheduler, 
> version 0.444 for the latest stable linux kernel. The main changes include a 
> resync against linux kernel version 3.12 and a rewritten mechanism for coping 
> with suspend to ram/disk and resume issues present in previous versions.
> 

Hi Con,

Any reason that BFS hardcodes CONFIG_SLUB as the only slab allocator 
allowed?  I've cc'd Pekka and Christoph and I'm sure they'd be interested 
in any reasons that CONFIG_SLAB doesn't work correctly with a different 
drop-in scheduler, or is it just that interactivity has tested better with 
slub?
