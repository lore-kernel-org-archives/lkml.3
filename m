Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaHOSl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:41:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:40804 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027AbaHOSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:41:24 -0400
Date: Fri, 15 Aug 2014 14:41:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Anand Moon <moon.linux@yahoo.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Felipe Balbi <balbi@ti.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Robert Nelson <robertcnelson@gmail.com>
Subject: Re: Random MAC address on my BeagleBone White
Message-ID: <20140815144120.58597f37@gandalf.local.home>
In-Reply-To: <53EE5233.6000605@yahoo.com>
References: <20140815134221.08c546a0@gandalf.local.home>
	<53EE5233.6000605@yahoo.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2014 00:02:19 +0530
Anand Moon <moon.linux@yahoo.com> wrote:

> Hi Steven,
> 
> Please follow the bellow link to set mac address.
> 
> http://www.armadeus.com/wiki/index.php?title=Ethernet_MAC_address
> 
> -Anand Moon

Hi,

My U-Boot already has a ethaddr defined. It's what is used by the
default kernel that came with the board (3.2).

U-Boot# printenv
[...]
ethaddr=d4:94:a1:8b:ec:78

The problem is that this is ignored by the latest kernel and it
replaces it with some random mac.

Note, I boot via bootp, thus it has to have a mac. That mac is what
tells my dhcp server what kernel image to load this board.

-- Steve

