Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3IKTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:22:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54317 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3IKTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:22:17 -0400
Date: Wed, 11 Sep 2013 13:22:16 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Convert kmalloc_node(...GFP_ZERO...) to
 kzalloc_node(...)
Message-ID: <20130911192216.GI28521@kernel.dk>
References: <11ab0469151bbb77f45c06e73ca61112179fd727.1377814810.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11ab0469151bbb77f45c06e73ca61112179fd727.1377814810.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29 2013, Joe Perches wrote:
> Use the helper function instead of __GFP_ZERO.

Applied.

-- 
Jens Axboe

