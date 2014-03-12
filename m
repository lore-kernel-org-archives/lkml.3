Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaCLQHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:07:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:50793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaCLQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:07:32 -0400
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
Date: Wed, 12 Mar 2014 17:06:59 +0100
Message-ID: <7613177.7hd4IoKUr4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140312124835.GA22450@lee--X1>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org> <20140312114257.GA17461@e106331-lin.cambridge.arm.com> <20140312124835.GA22450@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FGhUyYUZ2BB3AMBFbw6Wvp4iUCPYuWF7TR4X3dD+ElZ
 TVtvOQVObSKwCZEF0WgA4//XjMmCyoAX30TLtIVmc40XLK5aVT
 7Ma325x5ouMcUlNDWYM+6oSug+KkQ6se9h233XpMaSmto1b7ga
 5MKSCNwa+1W+PBLA2Z6mq5tAuEJ1y35kxzehmsk8bUrqLveOSe
 VCFf18Kx+2OEhqLDvkv1BYVctTfhAzrD4dbUQZBwxsZSqDI+pY
 QG8orRy4NHSSnqkYdZt+WWC9LRuGDiCrBSw80oG+50S+ePheGv
 5yzWdZxlpmTbBbCXY2RpVBky9PrUbo1LMxOQx0ZhQmlqMH5La1
 RYgGAZ7zOmW1lVskmitg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014 12:48:35 Lee Jones wrote:
> > > +This binding describes a SATA device.
> > > +
> > > +Required properties:
> > > + - compatible         : Must be "st,ahci"
> > 
> > Is there not a more specific name? This is awfully generic.
> 
> There isn't one. ST only have one AHCI driver. The driver is named as
> generically.

If it is this generic, can't you use the completely generic
ahci-platform driver and add a "generic-ahci" compatible string
to that?

	Arnd
