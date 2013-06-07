Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3FGA2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:28:09 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49272 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FGA2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:28:08 -0400
Date: Thu, 6 Jun 2013 17:23:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: lp8727: support the device tree feature
Message-ID: <20130607002347.GB7052@lizard.sbx05280.losalca.wayport.net>
References: <A874F61F95741C4A9BA573A70FE3998F82E5CF45@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5CF45@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 07:17:51AM +0000, Kim, Milo wrote:
> The interrupt and charging parameters are configurable in the device tree
> structure. In the board test, a GPIO is used for handling LP8727 interrupts.
> The device tree binding documentation is added also.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---

Applied, thanks!

Anton
