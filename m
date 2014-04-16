Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaDPATI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:19:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50776 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaDPATG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:19:06 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 16 Apr 2014 09:19:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Steven King <sfking@fdwdc.com>
Cc: linux-kernel@vger.kernel.org,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: v3.15-rc1 slab allocator broken on m68knommu (coldfire)
Message-ID: <20140416001931.GA17350@js1304-P5Q-DELUXE>
References: <201404141745.44279.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404141745.44279.sfking@fdwdc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:45:43PM -0700, Steven King wrote:
> git bisect suggests it starts somewhere around commit 
> f315e3fa1cf5b3317fc948708645fff889ce1e63 slab: restrict the number of objects 
> in a slab
> 
> but its kinda hard to tell as there is some compile breakage in there as well.

Hello, Steven.

Hmm... there is the fix on upstream v3.15-rc1 for build breakage.
See commit 24f870d('slab: fix wrongly used macro').
If slab allocator broken with this fix, please let me know.

Thanks.
