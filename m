Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaBNVSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:18:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaBNVSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:18:43 -0500
Message-ID: <52FE8817.4000504@zytor.com>
Date: Fri, 14 Feb 2014 13:18:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5D91.6060005@zytor.com> <alpine.DEB.2.02.1402141917320.21991@ionos.tec.linutronix.de> <52FE5ED4.4040508@zytor.com> <alpine.DEB.2.02.1402141924170.21991@ionos.tec.linutronix.de> <a1204336-ad8d-4f2f-8078-24f043f123e6@email.android.com> <alpine.DEB.2.02.1402142013150.21991@ionos.tec.linutronix.de> <52FE6DEF.1050607@zytor.com> <alpine.DEB.2.02.1402142030240.21991@ionos.tec.linutronix.de> <52FE7738.6040009@zytor.com> <alpine.DEB.2.02.1402142140430.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402142140430.21991@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 01:16 PM, Thomas Gleixner wrote:
>>
>> Well, the RSDP and RSDT/XSDT are nothing but pointers to other tables,
>> so if explicitly overridden I'm not sure if one actually would need
>> them.  That doesn't mean our current code will work without them, though.
> 
> I tried once to overload all of the tables, but failed miserably in
> the ACPI dungeon. RSDP was the major pain point IIRC.
> 

I suspect we need to handle the RSDP and RSDT/XSDT specially, since,
again, they are really just pointers to where to find the other tables.
 They are part of the discovery, not the data.

	-hpa


