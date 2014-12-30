Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaL3AcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:32:24 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51800 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3AcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:32:23 -0500
Date: Mon, 29 Dec 2014 16:32:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Bolle <pebolle@tiscali.nl>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/debug_pagealloc: remove obsolete Kconfig options
In-Reply-To: <1419310437-9193-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1412291632010.23782@chino.kir.corp.google.com>
References: <1419310437-9193-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014, Joonsoo Kim wrote:

> These are obsolete since commit e30825f1869a ("mm/debug-pagealloc:
> prepare boottime configurable on/off") is merged. Remove them.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
