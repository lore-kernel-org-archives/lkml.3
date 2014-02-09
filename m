Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaBIU4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:56:48 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36509 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBIU4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:56:47 -0500
Date: Sun, 9 Feb 2014 13:56:43 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Tejun Heo <tj@kernel.org>, josh@joshtriplett.org
Subject: Re: [PATCH 03/21] fs: Mark function as static in fs/bio-integrity.c
Message-ID: <20140209205643.GA2750@kernel.dk>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <3e778679e08fc73189ffaf4233fde057a0e75e68.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e778679e08fc73189ffaf4233fde057a0e75e68.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09 2014, Rashika Kheria wrote:
> Mark functions as static in bio-integrity.c because it is not used
> outside this file.
> 
> This eliminates the following warnings in bio-integrity.c:
> fs/bio-integrity.c:224:5: warning: no previous prototype for ‘bio_integrity_tag’ [-Wmissing-prototypes]

Applied 3+4, thanks.

-- 
Jens Axboe

