Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab3DYUNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:13:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:47431 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759186Ab3DYUNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:13:16 -0400
Message-ID: <1366920741.2869.32.camel@pasglop>
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
Date: Fri, 26 Apr 2013 06:12:21 +1000
In-Reply-To: <517980B0.3000401@gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
	 <1366596798-9457-2-git-send-email-robherring2@gmail.com>
	 <CAL_JsqKDF=hPEM0Jz-zZSXBCXBZ=gBjLWL6QDvq+nFWkqY3DMw@mail.gmail.com>
	 <1366911329.2869.31.camel@pasglop> <517980B0.3000401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 14:14 -0500, Rob Herring wrote:
> On 04/25/2013 12:35 PM, Benjamin Herrenschmidt wrote:
> > On Thu, 2013-04-25 at 10:23 -0500, Rob Herring wrote:
> >> Ben, Can I have your Ack for this? The change is straightforward and
> >> neither of the 2 drivers used the id parameter that is removed.
> > 
> > Didn't you get my mail about a compile failure caused by this patch ?
> 
> No, and I can't find any evidence of a mail in my inbox or in the list
> archives.

Odd...

> > 
 .../...

> You need patch 2 of this series to fix this:
> 
> driver core: move to_platform_driver to platform_device.h
> 
> which as Arnd pointed out needs to come first. I've fixed that in my
> tree, but I don't think it warrants another post.

Can I pull you tree from somewhere to test ?

Cheers,
Ben.

> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


