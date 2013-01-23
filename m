Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3AWITe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:19:34 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:61415 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3AWITc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:19:32 -0500
Date: Wed, 23 Jan 2013 08:19:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] regulator: Display in use regulators in sysfs
Message-ID: <20130123081927.GF15873@gmail.com>
References: <20130122094624.GJ6857@gmail.com>
 <20130123025125.GB5727@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130123025125.GB5727@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013, Mark Brown wrote:

> On Tue, Jan 22, 2013 at 09:46:24AM +0000, Lee Jones wrote:
> 
> > To locate a consumer that currently holds a regulattor, a new sysfs
> > entry is created. The consumer are published in
> > /sys/class/regulator/regulator.<#>/use.
> 
> We call our reference counts use count but this was in fact the original
> design, the local reference counts got dropped due to David Brownell's
> forceful insistance :/

So I should pull the patch?

How do you feel about being able to access it via sysfs? Good or bad
idea? If it's a good idea, I can always change the name of the
variable?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
