Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaAWMnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:43:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52531 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbaAWMnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:43:10 -0500
Date: Thu, 23 Jan 2014 09:43:24 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 RESEND] mtd: block2mtd: char mtd major and erasesize
 parameter check + mutex_destroy
Message-ID: <20140123124323.GA20713@localhost>
References: <20140122162843.15c3fb1e1318346339fcbff4@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140122162843.15c3fb1e1318346339fcbff4@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

On Wed, Jan 22, 2014 at 04:28:43PM +0800, Fabian Frederick wrote:
> -Deny use of a char mtd device to map as block device.
> -mutex_init when mtd structure is available.
> -fixme applied : check device size is a multiple of erasesize.
> -mutex_destroy on each device in block2mtd_exit and add_device failure.
> 

Hm... that sound like a lot of work for a single patch :-)

Care to chop it and submit a one-thing-per-patch series?

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
