Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3IWNpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:45:45 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.203]:18753 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441Ab3IWNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:45:43 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 09:45:41 EDT
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-45.messagelabs.com!1379943565!32172056!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <52404487.4080501@digi.com>
Date: Mon, 23 Sep 2013 15:39:19 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jonathan Cameron <jic23@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "marex@denx.de" <marex@denx.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>  <1374501843-19651-3-git-send-email-hector.palacios@digi.com>  <520AA3CD.1040008@kernel.org> <1376491467.18617.41.camel@hornet>  <52153B8E.7050309@free-electrons.com>  <df6d000d-c918-48ec-958c-c8529ae1b75f@email.android.com> <1377190299.2626.9.camel@hornet> <5217E999.7020408@kernel.org> <52403845.5020002@free-electrons.com>
In-Reply-To: <52403845.5020002@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 09/23/2013 02:47 PM, Alexandre Belloni wrote:
> Hector,
>
> I'd like to go forward with this and have a chance to see that included
> in 3.13. Do you mind if I rework your patch series by removing the DT
> part and then resubmit ?

I don't mind at all. Please go ahead.

>
> Regards,
>
>
> On 24/08/2013 01:00, Jonathan Cameron wrote:
>> On 08/22/13 17:51, Pawel Moll wrote:
>>> On Thu, 2013-08-22 at 07:17 +0100, Jonathan Cameron wrote:
>>>> I would favour option 2 though some of the discussions going on at the moment about
>>>> bindings might result in a generic description of this and any other bits of
>>>>   analog front end.
>>> Any link to this discussion? devicetree@vger.kernel.org doesn't seem to
>>> be involved (of course I may have simply missed the thread ;-)
>> Some cc's dropped off the discussion at some point that should have been there
>> and the topic has 'wandered' somewhat from where it started.
>>
>> https://lkml.org/lkml/2013/8/21/409
>>
>> and the couple of messages after that are probably the most relevant.
>>
>> Speaking of which the devicetree list on here was the old one, I've just switched
>> to the vger list you suggest above.
>>
>>
>>> Paweł
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
>


Best regards,
--
Hector Palacios
