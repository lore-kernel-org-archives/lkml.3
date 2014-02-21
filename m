Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaBUX2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:28:07 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43761 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBUX2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:28:05 -0500
Date: Fri, 21 Feb 2014 15:28:01 -0800
From: Jens <axboe@kernel.dk>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/bio-integrity: remove duplicate code
Message-ID: <20140221232801.GC29129@kernel.dk>
References: <53072633.2010106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53072633.2010106@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21 2014, Gu Zheng wrote:
> Most code of function bio_integrity_verify and bio_integrity_generate
> is the same, so introduce a help function bio_integrity_generate_verify()
> to remove the duplicate code.

Thanks, queued up for the next release.

-- 
Jens Axboe

