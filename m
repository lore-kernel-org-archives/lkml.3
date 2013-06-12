Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3FLLku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:40:50 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:42273 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3FLLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:40:48 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/5] ibmebus: convert of_platform_driver to platform_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1371014978.8250.175.camel@pasglop>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com> <1366596798-9457-2-git-send-email-robherring2@gmail.com> <CAL_JsqKDF=hPEM0Jz-zZSXBCXBZ=gBjLWL6QDvq+nFWkqY3DMw@mail.gmail.com> <1366911329.2869.31.camel@pasglop> <517980B0.3000401@gmail.com> <1366920741.2869.32.camel@pasglop> <517995D0.8020307@gmail.com> <CAL_JsqKXt-gFL4y_k-_dFktpk1JD_S2G+hUsoOavw8QugFMOKA@mail.gmail.com> <1371014978.8250.175.camel@pasglop>
Date: Wed, 12 Jun 2013 12:40:43 +0100
Message-Id: <20130612114043.9E69A3E0A56@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 15:29:38 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Wed, 2013-05-22 at 07:26 -0500, Rob Herring wrote:
> > > git://sources.calxeda.com/kernel/linux.git of-platform-removal
> > 
> > Ben,
> > 
> > Did you have a chance to test this? I want to get this into -next.
> 
> I tested the one in for-next (sorry for the high latency). Works fine.
> 
> Ack.

Added acks and applied to my for-next branch. Thanks!

g.
