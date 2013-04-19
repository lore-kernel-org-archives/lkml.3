Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968152Ab3DSJsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:48:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39614 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967950Ab3DSJr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:47:59 -0400
Message-ID: <1366364876.3077.51.camel@hornet>
Subject: Re: linux-next: manual merge of the clk tree with the arm-soc tree
From: Pawel Moll <pawel.moll@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 19 Apr 2013 10:47:56 +0100
In-Reply-To: <20130419172753.0e604e9bad0b7a26a8b52787@canb.auug.org.au>
References: <20130419172753.0e604e9bad0b7a26a8b52787@canb.auug.org.au>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Apr 2013 09:47:57.0684 (UTC) FILETIME=[F8EC6340:01CE3CE2]
X-MC-Unique: 113041910475707801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 08:27 +0100, Stephen Rothwell wrote:
> Hi Mike,
> 
> Today's linux-next merge of the clk tree got a conflict in
> arch/arm/mach-vexpress/v2m.c between commit dabfd8fb84ab ("ARM: vexpress:
> remove sp804 OF init") from the arm-soc tree and commit 6e973d2c4385
> ("clk: vexpress: Add separate SP810 driver") from the clk tree.
> 
> I fixed it up (I thnk - see below) and can carry the fix as necessary (no
> action is required).

Yep, this merge is fine, thanks!

Paweł


