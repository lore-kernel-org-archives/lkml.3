Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaFDXvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:51:25 -0400
Received: from longford.logfs.org ([213.229.74.203]:43484 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaFDXvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:51:22 -0400
Date: Wed, 4 Jun 2014 19:49:29 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140604234929.GC31276@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
 <20140428234039.GC6358@logfs.org>
 <20140428172219.4be61cf7.akpm@linux-foundation.org>
 <20140604231506.GA31276@logfs.org>
 <20140604162832.aba2abbbceb6308491a189d2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140604162832.aba2abbbceb6308491a189d2@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 June 2014 16:28:32 -0700, Andrew Morton wrote:
> 
> Sorry, it seems I'm better at losing stuff than I thought I was.

The trouble with forgetting stuff is that few people remember ever
doing so.  But they do remember other people forgetting stuff.

> I've restored the patch to the input queue.

Thanks!

Jörn

--
Maintenance in other professions and of other articles is concerned with
the return of the item to its original state; in Software, maintenance
is concerned with moving an item away from its original state.
-- Les Belady
