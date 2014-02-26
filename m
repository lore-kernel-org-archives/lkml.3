Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaBZJcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:32:14 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33968 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBZJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:32:10 -0500
Date: Wed, 26 Feb 2014 09:32:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
Message-ID: <20140226093203.GK9195@lee--X1>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
 <20140225115036.GF13246@lee--X1>
 <20140225121555.GB25940@sirena.org.uk>
 <20140225124050.GA7571@lee--X1>
 <20140225230721.GA2927@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140225230721.GA2927@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The advice here is usually that sending against -next is a good proxy
> > > for sending against the individual tree without having to figure out all
> > > the different trees - almost all of the time the effect is the same.
> > > This only applies when sending patches via e-mail, for git pulls it's an
> > > absolute no of course.
> 
> > Good point. But it's worth reiterating that this should only be done
> > if you have dependencies which haven't yet reached Mainline. 
> 
> It can be worth doing anyway with a subsystem that's actively developed
> since sometimees the dependencies are the other way - the APIs in Linus'
> tree may have gone away.

Then what happens if the tree that your patch finally gets sucked into
is pulled before the one you've written your code against? I'd say
basing your code on -next is generally a bad idea.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
