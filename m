Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3CUB4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:56:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47350 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3CUB4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:56:24 -0400
Message-ID: <514A68C6.707@hitachi.com>
Date: Thu, 21 Mar 2013 10:56:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: Re: [BUG][mvebu] mvneta: cannot request irq 25 on openblocks-ax3
References: <51486445.8040506@hitachi.com> <20130319133928.GE3137@localhost> <514873FB.5050202@hitachi.com> <514895C5.40706@free-electrons.com>
In-Reply-To: <514895C5.40706@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/20 1:43), Gregory CLEMENT wrote:
> Hi Masami,
> 
> You can try this patch if you want.
> I don't have the hardware today so I didn't test it.
> If you (and also Florian and Ezequiel) can test it and if it fixed
> the bug, then I will be able send a proper email for it,

Hi Gregory,

Thank you for giving me the latest patch.
I've tested it on OpenBlocks-AX4 and that fixed the problem!

Tested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


