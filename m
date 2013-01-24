Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3AXJLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:11:49 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:54184 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3AXJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:11:40 -0500
Date: Thu, 24 Jan 2013 09:11:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] regulator: Display in use regulators in sysfs
Message-ID: <20130124091134.GP15873@gmail.com>
References: <20130122094624.GJ6857@gmail.com>
 <20130123025125.GB5727@opensource.wolfsonmicro.com>
 <20130123081927.GF15873@gmail.com>
 <20130123155335.GC4565@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130123155335.GC4565@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013, Mark Brown wrote:

> On Wed, Jan 23, 2013 at 08:19:27AM +0000, Lee Jones wrote:
> > On Wed, 23 Jan 2013, Mark Brown wrote:
> 
> > > We call our reference counts use count but this was in fact the original
> > > design, the local reference counts got dropped due to David Brownell's
> > > forceful insistance :/
> 
> > So I should pull the patch?
> 
> Not sure what you mean by pull; a stright revert won't work.

Sorry, perhaps I should have been clearer. 

Is the patch any good, or should I throw it in the bin (pull it)?

> > How do you feel about being able to access it via sysfs? Good or bad
> > idea? If it's a good idea, I can always change the name of the
> > variable?
> 
> That or debugfs.

So the premise of the patch is good and is worth updating and upstreaming?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
