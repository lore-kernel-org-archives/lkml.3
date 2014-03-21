Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbaCURkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:40:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:52790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbaCURkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:40:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,704,1389772800"; 
   d="scan'208";a="504019210"
Message-ID: <1395423599.24683.56.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] UBI: block: Remove __initdata from
 ubiblock_param_ops
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 19:39:59 +0200
In-Reply-To: <1395225803-25037-1-git-send-email-richard@nod.at>
References: <1395225803-25037-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 11:43 +0100, Richard Weinberger wrote:
> You cannot mark these parameters as __initdata.
> Otherwise the data is gone upon module exit.
> 
> Fixes:
> [  172.045465] BUG: unable to handle kernel paging request at ffffffffa001db38
> [  172.046020] IP: [<ffffffff81067aa4>] destroy_params+0x24/0x50
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed to linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

