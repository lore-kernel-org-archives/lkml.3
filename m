Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaEFVK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:10:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55021 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948AbaEFVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:10:56 -0400
Date: Tue, 6 May 2014 23:10:41 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
Message-ID: <20140506211040.GF11243@piout.net>
References: <94c06375c1b44c8eb5233b0ccf2e4b13@BY2PR05MB048.namprd05.prod.outlook.com>
 <1399386481-18643-1-git-send-email-boris.brezillon@free-electrons.com>
 <aed75d16aa46476eb6f6c5b0d4bef30d@BLUPR05MB037.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed75d16aa46476eb6f6c5b0d4bef30d@BLUPR05MB037.namprd05.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/05/2014 at 19:06:56 +0000, Bryan Evenson wrote :
> 
> I'd assume this patch would be backported to the longterm releases?
> 

If by longterm, you mean the linux4sam tree, 3.10 branch, it is up to
Nicolas to take it. I believe it will be pretty easy to convince him ;)

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
