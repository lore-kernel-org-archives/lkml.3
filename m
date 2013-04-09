Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936827Ab3DIHQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:16:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46993
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934967Ab3DIHQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:16:08 -0400
Date: Tue, 9 Apr 2013 09:15:50 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: pull request: bcache fixes
Message-ID: <20130409071550.GT12244@kernel.dk>
References: <20130408204246.GG15749@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408204246.GG15749@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08 2013, Kent Overstreet wrote:
> Jens, here's the latest bcache fixes. All of it fairly minor:
> 
> The following changes since commit 169ef1cf6171d35550fef85645b83b960e241cff:
> 
>   bcache: Don't export utility code, prefix with bch_ (2013-03-28 12:50:55 -0600)
> 
> are available in the git repository at:
> 
>   http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> 
> for you to fetch changes up to cef5279735d3f6f0243e626963e6d5c84efade0a:
> 
>   bcache: Disable broken btree fuzz tester (2013-04-08 13:33:49 -0700)

Pulled in, thanks Kent.

-- 
Jens Axboe

