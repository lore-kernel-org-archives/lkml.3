Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab3DYUpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:45:11 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:57281 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3DYUpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:45:08 -0400
Message-ID: <517995D0.8020307@gmail.com>
Date: Thu, 25 Apr 2013 15:45:04 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH 1/5] ibmebus: convert of_platform_driver to platform_driver
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>  <1366596798-9457-2-git-send-email-robherring2@gmail.com>  <CAL_JsqKDF=hPEM0Jz-zZSXBCXBZ=gBjLWL6QDvq+nFWkqY3DMw@mail.gmail.com>  <1366911329.2869.31.camel@pasglop> <517980B0.3000401@gmail.com> <1366920741.2869.32.camel@pasglop>
In-Reply-To: <1366920741.2869.32.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 03:12 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-04-25 at 14:14 -0500, Rob Herring wrote:
>> On 04/25/2013 12:35 PM, Benjamin Herrenschmidt wrote:

[...]

>> You need patch 2 of this series to fix this:
>>
>> driver core: move to_platform_driver to platform_device.h
>>
>> which as Arnd pointed out needs to come first. I've fixed that in my
>> tree, but I don't think it warrants another post.
> 
> Can I pull you tree from somewhere to test ?

Here you go:

git://sources.calxeda.com/kernel/linux.git of-platform-removal

Rob
