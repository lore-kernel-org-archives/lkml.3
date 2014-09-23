Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIWETQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:19:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50524 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaIWETP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:19:15 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: sleeping while atomic in blk_free_devt
From: Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (12A365)
In-Reply-To: <20140923024947.GA4760@redhat.com>
Date: Mon, 22 Sep 2014 22:19:12 -0600
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <2F5968A1-7BAB-4B52-A579-2B4DDABA2997@kernel.dk>
References: <20140923024947.GA4760@redhat.com>
To: Dave Jones <davej@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sep 22, 2014, at 8:49 PM, Dave Jones <davej@redhat.com> wrote:
> 
> Just got this when removing a USB memory stick.
> 
> BUG: sleeping function called from invalid context at block/genhd.c:448

Fixed in for-linus, it's going out tomorrow.


