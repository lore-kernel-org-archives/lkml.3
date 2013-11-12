Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3KLPx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:53:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43205 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KLPxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:53:55 -0500
Message-ID: <52824EED.2080508@ti.com>
Date: Tue, 12 Nov 2013 10:53:17 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH 04/12] mtd: nand: davinci: move bindings under mtd
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-5-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D08@DNCE04.ent.ti.com>
In-Reply-To: <4F5844B3A985794BA902E12C070812375F8D08@DNCE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 November 2013 11:55 AM, Khoronzhuk, Ivan wrote:
> Move bindings under mtd. Do this in order to make davinci-nand
> driver usable by keystone architecture.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

