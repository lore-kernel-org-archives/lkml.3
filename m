Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaEIRGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:06:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47599 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757020AbaEIRGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:06:00 -0400
Date: Fri, 9 May 2014 14:05:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 5/9] mtd: nand: add sunxi NAND flash controller support
Message-ID: <20140509170526.GA9768@arch.cereza>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-6-git-send-email-b.brezillon.dev@gmail.com>
 <20140509160341.GA6984@arch.cereza>
 <536D069A.40401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536D069A.40401@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 May 06:47 PM, Boris BREZILLON wrote:
> > Can you add some documentation about this read-back stuff?
> 
> This has nothing to do with read-back, RB means ready/busy :-).
> 

Hehe... right... I guess I was thinking in read/busy.

See? That's why you need to document it: so it's fool-proof.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
