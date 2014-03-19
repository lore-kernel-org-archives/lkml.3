Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbaCSNYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:24:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42453 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965071AbaCSNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:24:45 -0400
Date: Wed, 19 Mar 2014 10:24:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] UBI: block: Remove __initdata from ubiblock_param_ops
Message-ID: <20140319132426.GB529@arch.cereza>
References: <1395225803-25037-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395225803-25037-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 19, Richard Weinberger wrote:
> You cannot mark these parameters as __initdata.
> Otherwise the data is gone upon module exit.
> 
> Fixes:
> [  172.045465] BUG: unable to handle kernel paging request at ffffffffa001db38
> [  172.046020] IP: [<ffffffff81067aa4>] destroy_params+0x24/0x50
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Thanks for the fix!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
