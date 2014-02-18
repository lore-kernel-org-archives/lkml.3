Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaBRWsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:48:43 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51485 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaBRWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:48:41 -0500
Date: Tue, 18 Feb 2014 14:48:38 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: linux-kernel@vger.kernel.org, Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH] mtip32xx: Reduce the number of unaligned writes to 2
Message-ID: <20140218224838.GH25515@kernel.dk>
References: <5303D4CB.8070804@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303D4CB.8070804@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18 2014, Asai Thambi S P wrote:
> Hi Jens,
> 
> Please include this for 3.14. It is a trivial change, hope it should be ok.

I have applied it. However, your mailer seems to be changing tabs to
spaces, so it had to be hand applied. Not a big deal for this patch, but
worth checking up on for bigger patches.

-- 
Jens Axboe

