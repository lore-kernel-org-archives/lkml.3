Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaAaAtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:49:42 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49374 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaAaAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:49:41 -0500
Date: Thu, 30 Jan 2014 16:49:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andiry Xu <andiry.xu@gmail.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: fix memmap= language in
 kernel-parameters.txt
In-Reply-To: <52EAEFD8.6030003@infradead.org>
Message-ID: <alpine.DEB.2.02.1401301649280.32652@chino.kir.corp.google.com>
References: <52EAEFD8.6030003@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Clean up descriptions of memmap= boot options.
> 
> Add periods (full stops), drop commas, change "used" to
> "reserved" or "marked".
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andiry Xu <andiry.xu@gmail.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
