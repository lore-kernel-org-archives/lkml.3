Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaDVXT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:19:56 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:32953 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaDVXTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:19:54 -0400
Date: Tue, 22 Apr 2014 16:19:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, dave.hansen@linux.intel.com
Subject: Re: [PATCH] mm: debug: make bad_range() output more usable and
 readable
In-Reply-To: <20140421180733.30BD5EFE@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1404221619150.16896@chino.kir.corp.google.com>
References: <20140421180733.30BD5EFE@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014, Dave Hansen wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Nobody outputs memory addresses in decimal.  PFNs are essentially
> addresses, and they're gibberish in decimal.  Output them in hex.
> 
> Also, add the nid and zone name to give a little more context to
> the message.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
