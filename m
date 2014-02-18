Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaBRU1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:27:00 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35568 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBRU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:26:58 -0500
Date: Tue, 18 Feb 2014 12:20:21 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Use macros from compiler.h instead of
 __attribute__((...))
Message-ID: <20140218202021.GC25515@kernel.dk>
References: <1392652036-24447-1-git-send-email-gidisrael@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392652036-24447-1-git-send-email-gidisrael@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17 2014, Gideon Israel Dsouza wrote:
> To increase compiler portability there are several macros defined
> in <linux/compiler.h> for various gcc __attribute((..)) constructs.
> I've made sure gcc these specific were replaced with the right
> macro and an #include <linux/compiler.h> was placed where needed.

Thanks, applied.

-- 
Jens Axboe

