Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaFFMB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:01:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41219 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750727AbaFFMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:01:57 -0400
Date: Fri, 6 Jun 2014 14:01:53 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Peter.Chen@freescale.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] usb: chipidea: add Berlin USB support
Message-ID: <20140606120153.GC32416@kwain>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401983326-19205-7-git-send-email-antoine.tenart@free-electrons.com>
 <53919E3A.7070008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53919E3A.7070008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Jun 06, 2014 at 12:55:54PM +0200, Sebastian Hesselbarth wrote:
> On 06/05/2014 05:48 PM, Antoine Ténart wrote:
> >+
> >+static const struct of_device_id ci_hdrc_berlin_of_match[] = {
> >+	{ .compatible = "marvell,berlin-usb" },
> 
> Looking at the driver, I can see no Berlin-specific code at all. Maybe
> we just take the chance and have a generic chipidea boiler plate driver
> now?

This driver does nothing special. If we define the PHY and the clock
properties as optional, we can do a generic driver here.


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
