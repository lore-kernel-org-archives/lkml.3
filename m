Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaBYMk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:40:58 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43271 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBYMk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:40:57 -0500
Date: Tue, 25 Feb 2014 12:40:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
Message-ID: <20140225124050.GA7571@lee--X1>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
 <20140225115036.GF13246@lee--X1>
 <20140225121555.GB25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140225121555.GB25940@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am. The trouble with basing your patches against -next is that it's
> > not stable, in that it is rebuilt every day. If your patches are
> > dependant on commits which haven't reached Mainline yet, then you
> > should rebase on the subsystem tree which they are contained in. All
> > patches in -next should be based on an -rc or a released kernel version.
> 
> The advice here is usually that sending against -next is a good proxy
> for sending against the individual tree without having to figure out all
> the different trees - almost all of the time the effect is the same.
> This only applies when sending patches via e-mail, for git pulls it's an
> absolute no of course.

Good point. But it's worth reiterating that this should only be done
if you have dependencies which haven't yet reached Mainline. 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
