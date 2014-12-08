Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaLHRVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:21:40 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34210 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaLHRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <54639423.3030607@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
	<1410553499-55951-2-git-send-email-s-anna@ti.com>
	<CAK=WgbZqj23J4M8n5FOkPdUOcyK3==TXgc3DfX=LKS6E8C+-Bg@mail.gmail.com>
	<54639423.3030607@ti.com>
Date: Mon, 8 Dec 2014 09:21:37 -0800
Message-ID: <CAJAp7OgqHsY+bpwfhrN6N=_r+Rf=ab84LX4LXf1b_GxYVQZkbQ@mail.gmail.com>
Subject: Re: [PATCHv6 1/5] Documentation: dt: add common bindings for hwspinlock
From: Bjorn Andersson <bjorn@kryo.se>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 9:08 AM, Suman Anna <s-anna@ti.com> wrote:
> Kumar, Mark, Rob,
>
> On 11/12/2014 09:14 AM, Ohad Ben-Cohen wrote:
>> Hi Suman,
>>
>> On Fri, Sep 12, 2014 at 11:24 PM, Suman Anna <s-anna@ti.com> wrote:
>>> This patch adds the generic common bindings used to represent
>>> a hwlock device and use/request locks in a device-tree build.
>>>
>> ...
>>>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

>>> ---
>>>  .../devicetree/bindings/hwlock/hwlock.txt          | 55 ++++++++++++++++++++++
>>>  1 file changed, 55 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>>
>> Please ask a DT maintainer to ACK this - otherwise I can't send this to Linus.
>>
>
> Can one of you ack this patch and the next patch [1] so that Ohad can
> pick up the series for 3.19? This series has been in works for quite
> some time now and was reviewed by each of you at some point of time
> (thanks!!), the cover letter [2] has the history of the changes.
>

Could we please have a statement from a DT maintainer so we could move
forward with this?

Regards,
Bjorn
