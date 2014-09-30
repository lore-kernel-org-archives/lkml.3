Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaI3IH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:07:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53064 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbaI3IHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:07:23 -0400
Date: Tue, 30 Sep 2014 10:07:20 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140930100720.45625804@bbrezillon>
In-Reply-To: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 23 Sep 2014 16:07:33 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello Huang, Brian,
> 
> This is just a new proposal to support raw accesses in a more standard way
> in the GPMI driver.
> This series has been tested on an imx28 board.
> 
> Any suggestions are welcome.

Brian, any chance you could take a look at this series and give your
opinion and/or suggest a new approach ?

Huang, did you have time to think about a better way to implement these
raw access functions ?

Best Regards,

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
