Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaHUTN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:13:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45518 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbaHUTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:13:55 -0400
Date: Thu, 21 Aug 2014 16:12:46 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Colin King <colin.king@canonical.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] UBI: block: fix dereference on uninitialized dev
Message-ID: <20140821191246.GA13322@arch.cereza>
References: <1408526378-12972-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408526378-12972-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Aug 10:19 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> commit 4df38926f337 ("UBI: block: Avoid disk size integer overflow")
> introduced a dereference on dev (which is not initialized at that
> point) when printing a warning message.  Re-order disk_capacity check
> after the dev is found.
> 
> Found by cppcheck:
>  [drivers/mtd/ubi/block.c:509]: (error) Uninitialized variable: dev
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Thanks a lot,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
