Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaBNSJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:09:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaBNSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:09:16 -0500
Message-ID: <52FE5BB6.9070405@zytor.com>
Date: Fri, 14 Feb 2014 10:08:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com>
In-Reply-To: <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 10:06 AM, Conrad Kostecki wrote:
> 
> Hm. I am not. The Soekris is my only device with an E6xx CPU. This one is special, as Soekris does not implement ACPI.
> I don't know, how other E6xx systems do work. I guess, there will have ACPI. There seem not to be many out there.
> This patch is now running for about six months without any problems for me.
> 
> I was also searching for some other systems. I found here only one manual.
> There are at least the same vendor/device id shown, as used also in Soekris.
> -> http://www.ekf.de/p/pc2/pc2_ug.pdf
> 
> Is there maybe any possibility to check for the specific Soekris model? At least MPTABLE identifies the Soekris:
> [    0.000000] MPTABLE: OEM ID: Soekris
> [    0.000000] MPTABLE: Product ID: net6501
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> 

Does it have DMI?

	-hpa


