Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaGGWqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:46:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33004 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaGGWqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:46:36 -0400
Date: Tue, 8 Jul 2014 00:46:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-ID: <20140707224634.GE18735@two.firstfloor.org>
References: <53B667F9.90306@bull.net>
 <87y4w6sbp7.fsf@tassilo.jf.intel.com>
 <53BA772C.6040506@bull.net>
 <20140707163003.GA18735@two.firstfloor.org>
 <20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can anyone demonstrate why we shouldn't just do

I was assuming due to memory usage: with 4K blocks 32K->64K

-Andi
