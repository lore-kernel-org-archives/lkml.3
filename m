Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaHEMCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:02:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:19432 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaHEMCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:02:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,804,1400050800"; 
   d="scan'208";a="571936619"
Message-ID: <1407240147.30675.29.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH 2/3] tty: serial: 8250: Add Mediatek UART driver
From: Alan Cox <alan@linux.intel.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@linaro.org, heikki.krogerus@linux.intel.com,
        paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org,
        dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com,
        mingo@elte.hu, balbi@ti.com, heiko@sntech.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 05 Aug 2014 13:02:27 +0100
In-Reply-To: <53E0C633.7060600@gmail.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
	 <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>
	 <53E0C633.7060600@gmail.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 17:25 +0530, Varka Bhadram wrote:
> On 08/05/2014 04:24 PM, Matthias Brugger wrote:
> 
> (...)
> 
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/serial_8250.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/clk.h>
> > +#include <linux/pm_runtime.h>
> > +#include "8250.h"
> > +
> 
> Better if we have includes in alphabetical order..


So 8250.h would be first and it wouldn't compile ???

Can we stick to serious critiques ?

Alan


