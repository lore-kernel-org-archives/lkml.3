Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3CSTtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:49:11 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59997 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3CSTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:49:09 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [BUG][mvebu] mvneta: cannot request irq 25 on openblocks-ax3
Date: Tue, 19 Mar 2013 20:48:41 +0100
Message-ID: <2482565.pAEcuMH9qj@bender>
Organization: OpenWrt
User-Agent: KMail/4.9.5 (Linux/3.5.0-25-generic; KDE/4.9.5; x86_64; ; )
In-Reply-To: <514895C5.40706@free-electrons.com>
References: <51486445.8040506@hitachi.com> <514873FB.5050202@hitachi.com> <514895C5.40706@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 March 2013 17:43:49 Gregory CLEMENT wrote:
> 
> Hi Masami,
> 
> You can try this patch if you want.
> I don't have the hardware today so I didn't test it.
> If you (and also Florian and Ezequiel) can test it and if it fixed
> the bug, then I will be able send a proper email for it,

I just tested your patch on RD-A370-A1 and DB-MV784MP-GP and it works fine, 
thanks! Feel free to add my Tested-by: Florian Fainelli <florian@openwrt.org> 
to your next submission.

Thanks!
-- 
Florian
