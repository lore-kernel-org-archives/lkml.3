Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbbA1EID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:08:03 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51758 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbbA1EIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:08:00 -0500
Date: Wed, 28 Jan 2015 13:07:57 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] zram: free meta out of init_lock
Message-ID: <20150128040757.GA577@swordfish>
References: <20150126141709.GA985@swordfish>
 <20150126160007.GC528@blaptop>
 <20150127021704.GA665@swordfish>
 <20150127031823.GA16797@blaptop>
 <20150127040305.GB665@swordfish>
 <20150128001526.GA25828@blaptop>
 <20150128002203.GB25828@blaptop>
 <20150128020759.GA343@swordfish>
 <20150128025707.GB32712@blaptop>
 <20150128035354.GA7790@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128035354.GA7790@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/28/15 12:53), Sergey Senozhatsky wrote:
> > So, I want to go with srcu. Do you agree? or another suggestion?
> 
> yes, I think we need to take a second look on srcu approach.
> 

... or we can ask lockdep to stop false alarming us and leave it as is.
I wouldn't say that ->init_lock is so hard to understand.
just as an option.

	-ss
