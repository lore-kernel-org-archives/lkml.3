Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaCRI1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:27:38 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61072 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaCRI1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:27:35 -0400
Date: Tue, 18 Mar 2014 08:27:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 6/8] mfd: lpc_ich: Change Avoton to iTCO v3
Message-ID: <20140318082730.GB25478@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-6-git-send-email-ptyser@xes-inc.com>
 <20140315200456.GE14815@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140315200456.GE14815@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The register layout of the Avoton is compatible with the iTCO v3
> > register layout.
> > 
> > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > Tested-by: Rajat Jain <rajatjain@juniper.net>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Cc: James Ralston <james.d.ralston@intel.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
> > Cc: linux-watchdog@vger.kernel.org
> > ---
> >  drivers/mfd/lpc_ich.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Acked-by: Wim Van Sebroeck <wim@iguana.be>

Acking patches two days after they've already been applied, it seldom
helpful.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
