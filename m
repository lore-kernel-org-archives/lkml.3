Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaFJWzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:55:32 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:48593 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaFJWza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:55:30 -0400
Date: Tue, 10 Jun 2014 15:55:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/1] mm/memory_hotplug.c: add __meminit to
 grow_zone_span/grow_pgdat_span
In-Reply-To: <1402422793-5928-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1406101555180.32203@chino.kir.corp.google.com>
References: <1402422793-5928-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Fabian Frederick wrote:

> grow_zone_span and grow_pgdat_span are only called by
> __meminit __add_zone
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: David Rientjes <rientjes@google.com>
