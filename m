Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaLQB1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:27:51 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40863 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaLQB1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:27:50 -0500
Date: Tue, 16 Dec 2014 17:27:47 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: remove deprecated comment
Message-ID: <20141217012747.GQ9759@ld-irv-0074>
References: <1417545429-11283-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417545429-11283-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 07:37:09PM +0100, Boris Brezillon wrote:
> Now that we have raw functions properly implemented we can remove this
> FIXME.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Pushed to l2-mtd.git/next. Thanks!

Brian
