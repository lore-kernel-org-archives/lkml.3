Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaKDJWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:22:55 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:45867 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaKDJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:22:52 -0500
Date: Tue, 4 Nov 2014 09:22:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "pure.logic@nexus-software.ie" <pure.logic@nexus-software.ie>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Message-ID: <20141104092246.GN17577@x1>
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com>
 <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
 <54574E35.1030402@nexus-software.ie>
 <1415092249.472.5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415092249.472.5.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Shevchenko, Andriy wrote:

> On Mon, 2014-11-03 at 09:43 +0000, Bryan O'Donoghue wrote:
> > On 03/11/14 07:39, Raymond Tan wrote:
> > > In Quark X1000, there's a single PCI device that provides both
> > > an I2C controller and a GPIO controller. This MFD driver will
> > > split the 2 devices for their respective drivers.
> > >
> > > This patch is based on Josef Ahmad's initial work for Quark enabling.
> > 
> > Hi Raymond.
> > 
> > I see support for interrupts on GPIO input has been dropped. In fact it 
> > doesn't appear you have any IRQ support here at all.
> > 
> > Could you detail the reasons why ?
> 
> In general the MFD drivers are just dispatchers which split an original
> compound device by its slices.

+1

That's a really nice way of putting it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
