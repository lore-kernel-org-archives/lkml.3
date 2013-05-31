Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3EaFoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:44:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:33707 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3EaFo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:44:27 -0400
Message-ID: <1369979047.3928.112.camel@pasglop>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chen Yuanquan-B41889 <B41889@freescale.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Date: Fri, 31 May 2013 15:44:07 +1000
In-Reply-To: <20130531051423.GA15505@roeck-us.net>
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
	 <51A5CAC1.6030800@freescale.com> <20130531051423.GA15505@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 22:14 -0700, Guenter Roeck wrote:
> On Wed, May 29, 2013 at 05:30:41PM +0800, Chen Yuanquan-B41889 wrote:
> > On 05/29/2013 01:35 AM, Guenter Roeck wrote:
> > >bios_add_device(). Drop explicit calls to pcibios_setup_device();
> > >this makes pcibios_setup_bus_devices() a noop function which could
> > >eve
> > 
> > Yeah, it's more reasonable to do the irq and DMA related initialization
> > in one code path for all devices.
> > 
> Any comments / feedback on the code itself ?

Sorry, I haven't had a chance to review it yet, I'm fairly bogged down
at the moment. I want to tread carefully because the previous iteration
of changing that stuff did break a few platforms in the end.

Cheers,
Ben.


