Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3EVM0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:26:45 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:40345 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3EVM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <517995D0.8020307@gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
	<1366596798-9457-2-git-send-email-robherring2@gmail.com>
	<CAL_JsqKDF=hPEM0Jz-zZSXBCXBZ=gBjLWL6QDvq+nFWkqY3DMw@mail.gmail.com>
	<1366911329.2869.31.camel@pasglop>
	<517980B0.3000401@gmail.com>
	<1366920741.2869.32.camel@pasglop>
	<517995D0.8020307@gmail.com>
Date: Wed, 22 May 2013 07:26:42 -0500
Message-ID: <CAL_JsqKXt-gFL4y_k-_dFktpk1JD_S2G+hUsoOavw8QugFMOKA@mail.gmail.com>
Subject: Re: [PATCH 1/5] ibmebus: convert of_platform_driver to platform_driver
From: Rob Herring <robherring2@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 3:45 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 04/25/2013 03:12 PM, Benjamin Herrenschmidt wrote:
>> On Thu, 2013-04-25 at 14:14 -0500, Rob Herring wrote:
>>> On 04/25/2013 12:35 PM, Benjamin Herrenschmidt wrote:
>
> [...]
>
>>> You need patch 2 of this series to fix this:
>>>
>>> driver core: move to_platform_driver to platform_device.h
>>>
>>> which as Arnd pointed out needs to come first. I've fixed that in my
>>> tree, but I don't think it warrants another post.
>>
>> Can I pull you tree from somewhere to test ?
>
> Here you go:
>
> git://sources.calxeda.com/kernel/linux.git of-platform-removal

Ben,

Did you have a chance to test this? I want to get this into -next.

Rob
