Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3BENVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:21:02 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51791
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab3BENU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:20:57 -0500
Date: Tue, 5 Feb 2013 14:19:55 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd build fix in case CONFIG_CRYPTO_HMAC is not set
Message-ID: <20130205131955.GT15092@kernel.dk>
References: <2148524.Qc3kYa9ye0@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2148524.Qc3kYa9ye0@fat-tyre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04 2013, Philipp Reisner wrote:
> The following changes since commit d88c3ab963d4cce09b25ef661b871bd7af6dad0d:
> 
>   drbd: only fail empty flushes if no good data is reachable (2013-01-30 10:40:33 +0100)
> 
> are available in the git repository at:
> 
>   git://git.drbd.org/linux-drbd.git for-jens-3.8-fix
> 
> for you to fetch changes up to 78aa7987a223e8542f2735dace439690c6171ac5:
> 
>   drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set (2013-02-04 18:14:03 +0100)

NOT pulled. Base the branch off my for-linus. When I pull the below into
that, I don't get a small patch, I get all changes from 3.7 to 3.8-rc5.

-- 
Jens Axboe

