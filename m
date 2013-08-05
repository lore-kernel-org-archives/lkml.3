Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3HENM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:12:26 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:34815 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3HENMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:12:24 -0400
Message-ID: <51FFA4B4.5080807@gmail.com>
Date: Mon, 05 Aug 2013 15:12:20 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Mark Rutland <mark.rutland@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: remove dmacap,memset from Device tree binding
References: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com> <1372762453-12018-2-git-send-email-sebastian.hesselbarth@gmail.com> <20130725153104.GH23879@titan.lakedaemon.net> <20130804010904.GB19280@titan.lakedaemon.net> <20130805095341.GA7594@e106331-lin.cambridge.arm.com> <20130805122638.GE19280@titan.lakedaemon.net>
In-Reply-To: <20130805122638.GE19280@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 14:26, Jason Cooper wrote:
> On Mon, Aug 05, 2013 at 10:53:41AM +0100, Mark Rutland wrote:
>> I'm not entirely sure on this. The property described is still true for
>> the device, even if the kernel's not using that information now. My
>> feeling would be to keep them, unless there's a plan to better describe
>> the properties of the XOR channels.
>>
>> It shouldn't harm the kernel to have some properties we don't use at
>> this point in time. If we want to reorganise the binding, the first step
>> would be to make the properties as deprecated, rather than removing them
>> outright.
>
> Ok, that matches what I was originally thinking.  The bindings are
> supposed to be OS-agnostic, so the fact that we no longer use it is
> irrelevant.  The hardware still has the capability.
>
> Sebastian, I'm just going to drop this patch.

Sure, I am fine with dropping it.

Sebastian

