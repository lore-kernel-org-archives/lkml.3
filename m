Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3EPVFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:05:13 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50099 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3EPVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:05:08 -0400
Date: Thu, 16 May 2013 14:05:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Cody P Schafer <cody@linux.vnet.ibm.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] memory_hotplug: use pgdat_resize_lock() in
 online_pages()
In-Reply-To: <20130515162054.1c76200ee9514ca8a2054628@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1305161404470.1348@chino.kir.corp.google.com>
References: <1368486787-9511-1-git-send-email-cody@linux.vnet.ibm.com> <1368486787-9511-4-git-send-email-cody@linux.vnet.ibm.com> <20130515162054.1c76200ee9514ca8a2054628@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Andrew Morton wrote:

> On Mon, 13 May 2013 16:13:06 -0700 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> 
> > mmzone.h documents node_size_lock (which pgdat_resize_lock() locks) as
> > follows:
> > 
> >         * Must be held any time you expect node_start_pfn, node_present_pages
> >         * or node_spanned_pages stay constant.  [...]
> 
> Yeah, I suppose so.  Although no present code sites actually do that.
> 

Agreed, I see no purpose in patches 2-4 in this series as mentioned in v2.
