Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3GGMBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 08:01:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53429 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3GGMB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 08:01:27 -0400
Subject: Re: [PATCH] swap: warn when a swap area overflows the maximum size
 (resent)
From: Raymond Jennings <shentino@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <1373197978.26573.7.camel@warfang>
References: <1373197450.26573.5.camel@warfang>
	 <1373197978.26573.7.camel@warfang>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Jul 2013 05:01:24 -0700
Message-ID: <1373198484.26573.8.camel@warfang>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...I hate you gmail...

On Sun, 2013-07-07 at 04:52 -0700, Raymond Jennings wrote:
> # lvresize /dev/system/swap --size 16G

Typo in the second test.

The first line should read:

# lvresize /dev/system/swap --size 64G

First ever serious patch, got excited and burned the copypasta.

> # mkswap /dev/system/swap
> # swapon /dev/system/swap
> 
> Jul  7 04:27:22 warfang kernel: Truncating oversized swap area, only
> using 33554432k out of 67108860k
> Jul  7 04:27:22 warfang kernel: Adding 33554428k swap
> on /dev/mapper/system-swap.  Priority:-1 extents:1 across:33554428k 


