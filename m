Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaEZFbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:31:44 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62312 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaEZFbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:31:42 -0400
Date: Sun, 25 May 2014 22:31:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] input: jornada680_kbd: Allocate resources using managed
 interfaces
Message-ID: <20140526053139.GB12890@core.coreip.homeip.net>
References: <20140524121709.GA6504@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140524121709.GA6504@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 05:47:09PM +0530, Himangi Saraogi wrote:
> This patch moves most data allocated in the probe function from
> unmanaged interfaces to managed interfaces. The kfrees and error
> handling code is done away with. Also, the unnecesary labels are
> removed and the function mrstouch_remove is removed as it becomes
> empty after removing the no longer required function calls. Also,
> linux/device.h is added to make sure the devm_*() routine declarations
> are unambiguously available.

Applied, thank you.

-- 
Dmitry
