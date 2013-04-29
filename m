Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3D2RxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:53:03 -0400
Received: from nm19.access.bullet.mail.sp2.yahoo.com ([98.139.44.146]:24909
	"EHLO nm19.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab3D2RxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:53:00 -0400
X-Yahoo-Newman-Id: 746034.92436.bm@smtp118.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jkX71r4VM1mj5vcKQx3mgoVJbSh_FkdEPaYjx0EO6XDg46r
 UvcsPFHUqpKbB9GiodlAA00cL.Q98eXC_AMQb03uvwXxdBNrVEjf0omqrexR
 DQPeDe8abbkZBXhYDpULdaVMJ9lFoVvpA3e.KGH1UmiGF_VeGRtC2xVygljZ
 CsTSYVa1aXXw2i0xUbuxJInBC08t9D_hCnAhkWHPY.ITkSWeD.5RZlb4ZPoY
 DPdsJkIaJt10q8sXx6NXUCLq1sCGhUGcCU4mSnFINeOhhanQR6M5q3RUQygY
 bvlnx04tMYqlO8J0ryviGI.49gupYkmkbHXm46VhYkCB9pdpbxQ1ujRly0Il
 LdMO45VDL1NYboaDZQfDtJ3m8vG1dzbvrt1bue6FvzMMBbPNSwEgVQsOYc8L
 TCImKxMpPlSWSj_wayHGPpARAIi8CyZgXX2LrBNg0Rl5G7QH.roTstbXjLjf
 OpqxmUYZYfuowdkqBC_HMeKG1Qg3SWDvmJM4EGA4-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp118.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 17:52:59 +0000 UTC
Date: Mon, 29 Apr 2013 10:52:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 2/7] watchdog: bcm63xx_wdt: use
 devm_ioremap_nocache()
Message-ID: <20130429175259.GB5183@roeck-us.net>
References: <000c01ce44bc$cfed7830$6fc86890$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01ce44bc$cfed7830$6fc86890$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:34:57PM +0900, Jingoo Han wrote:
> Use devm_ioremap_nocache() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
