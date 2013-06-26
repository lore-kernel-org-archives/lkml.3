Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3FZQXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:23:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:23987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3FZQXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="360912882"
Message-ID: <1372263786.8177.75.camel@envy.home>
Subject: Re: [PATCH 2/8] pch_uart: Add uart_clk selection for the MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, linux-serial@vger.kernel.org
Date: Wed, 26 Jun 2013 09:23:06 -0700
In-Reply-To: <51CA977D.3050802@suse.cz>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	   <6cc125b9eb85dd3cae4a2496fdb7f0d17b18f930.1372211451.git.dvhart@linux.intel.com>
	   <20130626023143.GB23320@kroah.com> <1372216578.8177.9.camel@envy.home>
	   <20130626033926.GA27165@kroah.com> <1372219125.8177.12.camel@envy.home>
	  <51CA8D91.6000708@suse.cz> <1372231162.8177.70.camel@envy.home>
	 <51CA977D.3050802@suse.cz>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 09:25 +0200, Jiri Slaby wrote:
> On 06/26/2013 09:19 AM, Darren Hart wrote:
> > You can't actually use this driver on 64 bit as there is no hardware,
> 
> Oh, so is this another candidate for adding dependson (X86_32 ||
> COMPILE_TEST) as well as the other *_PCH options?

As far as I know it isn't that you couldn't use it with a 64b CPU, it
just hasn't been. I'm happy to use a long as you suggest.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

