Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3HVULD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:11:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35293 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3HVUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:10:59 -0400
Message-ID: <5216704F.60007@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:10:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
References: <20130618092516.GC18663@ab42.lan> <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com> <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com> <20130805115118.GF20936@ab42.lan> <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com> <20130821155751.GB3046@ab42.lan>
In-Reply-To: <20130821155751.GB3046@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 09:57 AM, Christian Ruppert wrote:
> On Wed, Aug 14, 2013 at 06:53:56PM +0200, Linus Walleij wrote:
>> On Mon, Aug 5, 2013 at 1:51 PM, Christian Ruppert
>> <christian.ruppert@abilis.com> wrote:
>>> [Me]
>>>> I don't see any of the port concept creeping into the device tree
>>>> in this version and that is how I think it should be kept:
>>>> the "port" particulars is a thing for the driver and not the
>>>> device tree.
...
>>> In the driver under discussion, pin groups are defined for every
>>> "interface" to make sure that interfaces can be requested in an
>>> orthogonal way by different modules and modules don't have to be "aware"
>>> of which interfaces are grouped into which port (and which other modules
>>> request which other interfaces). A request either succeeds or fails.
>>> Resource management (which interfaces can be mapped simultaneously) is
>>> done inside the pinctrl driver.
>>
>> OK
> 
> This actually looks 100% coherent with Documentation/pinctrl.txt. But
> then I don't understand Stephen's request to introduce the concept of
> "ports" in the device tree. IMHO ports are a hardware limitation which
> should be managed inside the pinctrl driver and if possible not leak
> out of it. Also (as stated above), the concept of "ports" does not even
> exist in the pinmux framework so why introduce it for DT?
> 
> I might have thoroughly misunderstood you here, Stephen. Please be
> patient with me and explain once more.

I don't think I asked for ports to be represented in DT. Do you have
more context?
