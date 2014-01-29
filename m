Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaA2ADN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:03:13 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60956 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaA2ADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:03:11 -0500
Date: Tue, 28 Jan 2014 16:03:07 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: Re: [PATCH v2] mtd: block2mtd: Add mutex_destroy
Message-ID: <20140129000307.GC8919@ld-irv-0074>
References: <20140125104508.c562066b2276aad0cb3934ee@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125104508.c562066b2276aad0cb3934ee@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 10:45:08AM +0800, Fabian Frederick wrote:
> mutex_destroy added on each device in block2mtd_exit and add_device failure
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Pushed to l2-mtd.git/next. Thanks!

Brian
