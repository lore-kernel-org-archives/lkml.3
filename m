Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaCLRPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:15:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48274 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbaCLRO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:14:58 -0400
Date: Wed, 12 Mar 2014 17:14:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "DCG_UPD_stlinux_kernel@list.st.com" 
	<DCG_UPD_stlinux_kernel@list.st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH v2 1/3] ata: ahci_st: Provide DT bindings for ST's SATA
 implementation
Message-ID: <20140312171452.GE22450@lee--X1>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
 <20140312114257.GA17461@e106331-lin.cambridge.arm.com>
 <20140312124835.GA22450@lee--X1>
 <7613177.7hd4IoKUr4@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7613177.7hd4IoKUr4@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +This binding describes a SATA device.
> > > > +
> > > > +Required properties:
> > > > + - compatible         : Must be "st,ahci"
> > > 
> > > Is there not a more specific name? This is awfully generic.
> > 
> > There isn't one. ST only have one AHCI driver. The driver is named as
> > generically.
> 
> If it is this generic, can't you use the completely generic
> ahci-platform driver and add a "generic-ahci" compatible string
> to that?

It pretty much does. The only 'special' functionality we handle in
the driver are resets and configuring the OOB. However, both are
required.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
