Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3FLFa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:30:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:54424 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab3FLFaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:30:25 -0400
Message-ID: <1371014978.8250.175.camel@pasglop>
Subject: Re: [PATCH 1/5] ibmebus: convert of_platform_driver to
 platform_driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Mackerras <paulus@samba.org>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 12 Jun 2013 15:29:38 +1000
In-Reply-To: <CAL_JsqKXt-gFL4y_k-_dFktpk1JD_S2G+hUsoOavw8QugFMOKA@mail.gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
	 <1366596798-9457-2-git-send-email-robherring2@gmail.com>
	 <CAL_JsqKDF=hPEM0Jz-zZSXBCXBZ=gBjLWL6QDvq+nFWkqY3DMw@mail.gmail.com>
	 <1366911329.2869.31.camel@pasglop> <517980B0.3000401@gmail.com>
	 <1366920741.2869.32.camel@pasglop> <517995D0.8020307@gmail.com>
	 <CAL_JsqKXt-gFL4y_k-_dFktpk1JD_S2G+hUsoOavw8QugFMOKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 07:26 -0500, Rob Herring wrote:
> > git://sources.calxeda.com/kernel/linux.git of-platform-removal
> 
> Ben,
> 
> Did you have a chance to test this? I want to get this into -next.

I tested the one in for-next (sorry for the high latency). Works fine.

Ack.

Cheers,
Ben.


