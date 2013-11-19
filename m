Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3KSOoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:44:00 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:17119 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3KSOn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:43:57 -0500
Date: Tue, 19 Nov 2013 15:43:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <devicetree@vger.kernel.org>, <wni@nvidia.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <grant.likely@linaro.org>
Subject: Re: [lm-sensors] [PATCHv9 02/20] thermal: introduce device tree
 parser
Message-ID: <20131119154330.1951a978@endymion.delvare>
In-Reply-To: <528A27EE.9090604@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
	<1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
	<20131115090736.4f360dc8@endymion.delvare>
	<1384754650.2316.32.camel@rzhang-lenovo>
	<528A27EE.9090604@ti.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo, Rui,

I don't want to enter a long discussion here. I don't see get_trend()
being implemented by any currently existing hwmon driver. But if you
think future monitoring chips will be different and will be able to
implement get_trend(), well, you'll know better.

-- 
Jean Delvare
