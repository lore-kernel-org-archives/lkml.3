Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaEWNIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:08:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbaEWNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:08:47 -0400
Message-ID: <537F4855.70201@free-electrons.com>
Date: Fri, 23 May 2014 15:08:37 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
References: <20140523104534.467b452b@canb.auug.org.au>
In-Reply-To: <20140523104534.467b452b@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 23/05/2014 02:45, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-mvebu/board-v7.c between commit 8ae2473d96f1 ("ARM: l2c:
> mvebu: convert to generic l2c OF initialisation") from the arm tree and
> commit 5686a1e5aa43 ("bus: mvebu: pass the coherency availability
> information at init time") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

This fix seems to be the good thing to do.

Thanks,

Gregory


> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
