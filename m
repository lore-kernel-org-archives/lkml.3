Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3EaFOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:14:02 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62047 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3EaFNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:13:55 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 May 2013 22:14:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chen Yuanquan-B41889 <B41889@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
Message-ID: <20130531051423.GA15505@roeck-us.net>
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
 <51A5CAC1.6030800@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A5CAC1.6030800@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 05:30:41PM +0800, Chen Yuanquan-B41889 wrote:
> On 05/29/2013 01:35 AM, Guenter Roeck wrote:
> >bios_add_device(). Drop explicit calls to pcibios_setup_device();
> >this makes pcibios_setup_bus_devices() a noop function which could
> >eve
> 
> Yeah, it's more reasonable to do the irq and DMA related initialization
> in one code path for all devices.
> 
Any comments / feedback on the code itself ?

Thanks,
Guenter
