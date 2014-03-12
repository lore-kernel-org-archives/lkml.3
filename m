Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaCLTAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:00:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaCLTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:00:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "DCG_UPD_stlinux_kernel@list.st.com" 
	<DCG_UPD_stlinux_kernel@list.st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH v2 1/3] ata: ahci_st: Provide DT bindings for ST's SATA implementation
Date: Wed, 12 Mar 2014 19:59:52 +0100
Message-ID: <5284929.ZWl2X8pt1x@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140312171452.GE22450@lee--X1>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org> <7613177.7hd4IoKUr4@wuerfel> <20140312171452.GE22450@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mTinHbRuLNn6B74dKs6VGakmL5EGnpX0/k2htqE68NH
 nHtkefjl3u4fv7e4gGMWBrqMH5nSGc27dzx8sfC4YCftJDZjJH
 lPY2bLFPl5yxQno2/PHInCOB/S9RcyH8oeE5DL/qNbA0njXrEN
 R/pEGzgvFwFyToiWSG3pUXXBcwKpnpqhjJdaORnjFcsA5+5tC4
 grOsxxBiphCgc4VwLjS9yFf853qqKqVW8WV6gNXPGwJEB/1KJp
 kzpVzsGJW/XAsJi32dJuLBOancLzDwMU+CsSvF7Dd8yHbTxVbE
 5Tw5GvgegsN+KyUTNmk8cnSbG0RM7D6p+BF3bjBNbP1On2MP3Q
 SncRmpt9O89KHXzosLY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014 17:14:52 Lee Jones wrote:
> > > > > +This binding describes a SATA device.
> > > > > +
> > > > > +Required properties:
> > > > > + - compatible         : Must be "st,ahci"
> > > > 
> > > > Is there not a more specific name? This is awfully generic.
> > > 
> > > There isn't one. ST only have one AHCI driver. The driver is named as
> > > generically.
> > 
> > If it is this generic, can't you use the completely generic
> > ahci-platform driver and add a "generic-ahci" compatible string
> > to that?
> 
> It pretty much does. The only 'special' functionality we handle in
> the driver are resets and configuring the OOB. However, both are
> required.

The reset handling should be easy to add to the generic driver
usign as an optional property if I'm not mistaken.

What is OOB?

	Arnd
