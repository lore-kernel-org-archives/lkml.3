Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3JBNym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:54:42 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38997 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JBNyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:54:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark Brown <broonie@kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130926144743.GQ19304@sirena.org.uk>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1380203295-11030-1-git-send-email-ldewangan@nvidia.com>
 <20130926144743.GQ19304@sirena.org.uk>
Message-ID: <20131002135434.9338.99565@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: wm831x: get rid of the implementation of remove function
Date: Wed, 02 Oct 2013 06:54:34 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Brown (2013-09-26 07:47:43)
> On Thu, Sep 26, 2013 at 07:18:15PM +0530, Laxman Dewangan wrote:
> > The remove function implemented for platform driver's remove callback
> > just return 0 as part of its implementation.
> > 
> > Remove this APIs and do not pass the valid .remove for platform driver.
> 
> Yes, this should have been done when the driver was coverted to
> devm_clk_register()
> 
> Acked-by: Mark Brown <broonie@linaro.org>

Taken into clk-next.

Thanks,
Mike
