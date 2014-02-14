Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaBNSWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:22:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56890 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaBNSW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:22:29 -0500
Message-ID: <52FE5ED4.4040508@zytor.com>
Date: Fri, 14 Feb 2014 10:22:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5D91.6060005@zytor.com> <alpine.DEB.2.02.1402141917320.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402141917320.21991@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 10:21 AM, Thomas Gleixner wrote:
> On Fri, 14 Feb 2014, H. Peter Anvin wrote:
> 
>> On 02/14/2014 10:13 AM, Conrad Kostecki wrote:
>>>>
>>>> Does it have DMI?
>>>
>>> Unfortunately not.
>>>
>>> # dmidecode 2.12
>>> # No SMBIOS nor DMI entry point found, sorry.
>>>
>>
>> Sigh.  Does anyone have contacts at Soekris who can complain about this
>> stuff?
> 
> Well, lots of embedded stuff comes with a crippled BIOS. And there is
> often no way to get any BIOS fixes from the vendor through the
> subvendors and supplier chain.
> 
> I wish we could just use devicetree for such cases and fix the crud
> ourself.
> 

We'd have to identify the platform, which is the main problem.  Right
now we support quirking for DMI or PCI, but I don't think we do for MPTABLE.

	-hpa


