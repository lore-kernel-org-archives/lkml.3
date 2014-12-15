Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879AbaLOUx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:53:27 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:41296 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaLOUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:53:25 -0500
Date: Mon, 15 Dec 2014 22:53:16 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Aleksey Makarov <feumilieu@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Leonid Rosenboim <lrosenboim@caviumnetworks.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 09/14] MIPS: OCTEON: Add ability to used an initrd from a
 named memory block.
Message-ID: <20141215205316.GA10323@fuloong-minipc.musicnaut.iki.fi>
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
 <1418666603-15159-10-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418666603-15159-10-git-send-email-aleksey.makarov@auriga.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 09:03:15PM +0300, Aleksey Makarov wrote:
> From: David Daney <david.daney@cavium.com>
> 
> If 'rd_name=xxx' is passed to the kernel, the named block with name
> 'xxx' is used for the initrd.

Maybe use "initrd_name" for consistency or even just "initrd"
(if the xxx is not in form of "address,size" you could assume it to refer
to a named block).

A.
