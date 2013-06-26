Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3FZVY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:24:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:5059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab3FZVY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,946,1363158000"; 
   d="scan'208";a="360118303"
Message-ID: <1372281896.2720.35.camel@envy.home>
Subject: Re: [PATCH 3/8] gpio-sch: Add sch_gpio_resume_set_enable()
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 26 Jun 2013 14:24:56 -0700
In-Reply-To: <ea9c188e8ed12eccb6807f975285fb6274b21de4.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <ea9c188e8ed12eccb6807f975285fb6274b21de4.1372211451.git.dvhart@linux.intel.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 18:53 -0700, Darren Hart wrote:
> Allow for enabling and disabling of the resume well GPIOs. The E6xx Atom
> CPUs multiplex the resume GPIO 2:0 lines with LVDS and individual board
> drivers need to be able to enable or disable the lines appropriately.
> 
> Unfortunately, the information regarding if the pins are being used for
> LVDS or GPIO is board specific and may not be available to the gpio-sch
> driver at probe time.

Given the discussion on the platform/x86 minnowboard drivers, I believe
this patch can be dropped. Please do not pull.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

