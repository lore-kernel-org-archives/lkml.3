Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaCFUSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:18:34 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35900 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbaCFUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:18:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+WI/Ml6MA8F3uNmb11PbNnTdPJUhdguT4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1960B53C254
Date: Thu, 6 Mar 2014 15:18:03 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] pinctrl: mvebu: silence WARN to dev_warn
Message-ID: <20140306201803.GL1872@titan.lakedaemon.net>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393977790-29110-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393977790-29110-4-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:03:10AM +0100, Sebastian Hesselbarth wrote:
> Pinctrl will WARN on missing DT resources, which is a little bit too
> noisy. Use dev_warn with FW_BUG instead.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk> 
> Cc: Jason Cooper <jason@lakedaemon.net> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: devicetree@vger.kernel.org 
> Cc: linux-arm-kernel@lists.infradead.org 
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/pinctrl/mvebu/pinctrl-dove.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to mvebu/pinctrl

thx,

Jason.
