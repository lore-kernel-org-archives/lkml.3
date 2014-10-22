Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaJVJA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:00:57 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65367 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaJVJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:00:55 -0400
Date: Wed, 22 Oct 2014 02:00:51 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Rob Ward <robert.ward114@googlemail.com>
Cc: joern@lazybastard.org, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: phram: fix asm/io.h include usage
Message-ID: <20141022090051.GP16128@brian-ubuntu>
References: <alpine.DEB.2.10.1410212010210.7838@rob-thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410212010210.7838@rob-thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 08:14:00PM +0100, Rob Ward wrote:
> From ca36c5ca9adbe1d3c107e5ff22e8d0db5dddb1b9 Mon Sep 17 00:00:00 2001
> From: Rob Ward <robert.ward114@googlemail.com>
> Date: Tue, 21 Oct 2014 20:01:09 +0100
> Subject: [PATCH] mtd: phram: fix asm/io.h include usage
> 
> Modify phram to include <linux/io.h> rather than <asm/io.h>
> 
> Signed-off-by: Rob Ward <robert.ward114@googlemail.com>

Pushed to l2-mtd.git.

Brian
