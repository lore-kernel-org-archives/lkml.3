Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaLAXO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:14:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408AbaLAXO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:14:27 -0500
Message-ID: <547CF650.4070907@suse.de>
Date: Tue, 02 Dec 2014 00:14:24 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com> <547CCEE3.6020806@suse.de> <fb6f17c51aef4a498eb2a3e01a81df34@BN1BFFO11FD017.protection.gbl> <e016ae7c103a4fbd844826c9e25fe9c2@BY2FFO11FD036.protection.gbl>
In-Reply-To: <e016ae7c103a4fbd844826c9e25fe9c2@BY2FFO11FD036.protection.gbl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.12.2014 um 23:56 schrieb Sören Brinkmann:
> On Mon, 2014-12-01 at 01:24PM -0800, Sören Brinkmann wrote:
>> On Mon, 2014-12-01 at 09:26PM +0100, Andreas Färber wrote:
>>> Am 01.12.2014 um 19:42 schrieb Soren Brinkmann:
>>>> Add USB nodes to zc702, zc706 and zed device trees.
>>>>
>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>> ---
>>>>  arch/arm/boot/dts/zynq-7000.dtsi | 22 +++++++++++++++++++++-
>>>>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
>>>>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
>>>>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
>>>>  4 files changed, 52 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
>>>> index ce2ef5bec4f2..9ed60938f301 100644
>>>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>>>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> [...]
>>>> @@ -324,6 +344,6 @@
>>>>  			reg = <0xf8005000 0x1000>;
>>>>  			reset = <0>;
>>>>  			timeout-sec = <10>;
>>>> -		};
>>>> +		} ;
>>>>  	};
>>>>  };
>>>
>>> Unrelated accidental change here though. :)
> 
> Since a v2 is needed now, does this really require a dedicated patch to
> fix this bogus space here or do we just look the other way?

Sorry, I don't understand the question: If as you say a v2 is needed,
why knowingly introduce a space between } and ; in your patch? Maybe I'm
missing something or you're looking at the patch in reverse...?

Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
