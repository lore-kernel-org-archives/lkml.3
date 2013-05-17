Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3EQNQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:16:52 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59120
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab3EQNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:16:51 -0400
Date: Fri, 17 May 2013 15:16:40 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v2] block: remove refs to XD disks from documentation
Message-ID: <20130517131640.GD697@kernel.dk>
References: <1368796121-4593-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368796121-4593-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17 2013, Linus Walleij wrote:
> Commit d1a6f4f19728d6e90480e53601a90fc9f6a348ad
> "block: delete super ancient PC-XT driver for 1980's hardware"
> deleted the XD disk driver, but there are still a few
> references to it in the documentation directory. Delete
> the remnants and thus also free up the major block device
> 13 for reuse.

Thanks, applied.

-- 
Jens Axboe

