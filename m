Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaGGQbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:31:01 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60394 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaGGQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:31:00 -0400
Date: Mon, 7 Jul 2014 18:30:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sebastien Buisson <sebastien.buisson@bull.net>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-ID: <20140707163058.GB18735@two.firstfloor.org>
References: <53B667F9.90306@bull.net>
 <87y4w6sbp7.fsf@tassilo.jf.intel.com>
 <53BA772C.6040506@bull.net>
 <20140707163003.GA18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707163003.GA18735@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> config BH_LARGE_LRU
> 	bool

should be def_bool y

> 	depends on (EXT4_FS && QUOTA)
> 
> config BH_LRU_SIZE
> ....
> 	default "16" if BH_LARGE_LRU
> 	default "8" if !BH_LARGE_LRU
> 
> -Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
