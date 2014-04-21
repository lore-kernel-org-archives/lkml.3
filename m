Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaDUSas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:30:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43615 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753711AbaDUSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:30:45 -0400
Date: Mon, 21 Apr 2014 20:30:37 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Chao Xie <xiechao.mail@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] fixing regressions caused by Dove in MULTI_V7
Message-ID: <20140421203037.6ab02445@skate>
In-Reply-To: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20140414151236.75f8816d@skate>
	<1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian, Russell,

On Tue, 15 Apr 2014 20:15:58 +0200, Sebastian Hesselbarth wrote:
> This is a patch set fixing regressions in v3.15-rc1 ultimately caused
> by adding DT-enabled Marvell Dove to MULTI_V7. There was a fix
> introduced late in the merge window to fix a related regression for
> non-PJ4 architectures, that turned out to introduce another regression
> on PJ4B-based Armada 370/XP.

[...]

> Russell, please let me know if/when you are happy with the fixes
> and the improvement. I'll be adding them to your patch tracker then.

Any plans towards merging those patches, or at least PATCH 1 to 4 ?
They fix a regression on 3.15-r1 affecting mvebu platforms, and it
would be good to have that fixed by 3.15 final.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
