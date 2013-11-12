Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3KLPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:40:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35789 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:40:53 -0500
Message-ID: <52824BE3.40504@ti.com>
Date: Tue, 12 Nov 2013 10:40:19 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
CC: <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: Fwd: [PATCH 6/8] watchdog: davinci: reuse driver for keystone
 arch
References: <1383680783-12114-7-git-send-email-ivan.khoronzhuk@ti.com> <527A28DE.4030906@ti.com>
In-Reply-To: <527A28DE.4030906@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 November 2013 06:32 AM, ivan.khoronzhuk wrote:
> The keystone arch use the same IP watchdog, so add "ti,keystone-wdt"
> compatible and correct identity.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

