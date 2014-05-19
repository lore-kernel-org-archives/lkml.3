Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaESPEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:04:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaESPEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:04:44 -0400
Date: Mon, 19 May 2014 08:04:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Fix theoretical division by 0 in super_cache_scan().
Message-ID: <20140519150443.GA9652@infradead.org>
References: <201405172102.GII52606.JtMOQOOFVHFLFS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201405172102.GII52606.JtMOQOOFVHFLFS@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
