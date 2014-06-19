Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbaFSJNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:13:31 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55912 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452AbaFSJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:13:29 -0400
Date: Thu, 19 Jun 2014 02:13:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: slab.h: wrap the whole file with guarding macro
In-Reply-To: <53A29158.2050809@samsung.com>
Message-ID: <alpine.DEB.2.02.1406190213070.13670@chino.kir.corp.google.com>
References: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.02.1406181321010.10339@chino.kir.corp.google.com> <53A29158.2050809@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Andrey Ryabinin wrote:

> I had to do some modifications in this file for some reasons, and for me it was hard to not
> notice lack of endif in the end.
> 

Ok, cool, I don't think there's any need for a stable backport in that 
case.  Thanks for fixing it!
