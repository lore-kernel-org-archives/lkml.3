Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbaIIP1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:27:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41562 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaIIP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:27:19 -0400
Message-ID: <540F1C43.2080708@zytor.com>
Date: Tue, 09 Sep 2014 08:26:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
CC: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com> <540F06F1.1040608@lsexperts.de> <alpine.DEB.2.10.1409091649510.11037@nanos>
In-Reply-To: <alpine.DEB.2.10.1409091649510.11037@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 07:54 AM, Thomas Gleixner wrote:
> 
> @hpa: You asked whether this might affect any other e6xx devices.
> 
> According to the atom e6xx-series datasheet the HPET is non optional
> and always memory mapped to 0xfed00000. I don't see how that would
> harm any machine which has the hpet proper advertised via ACPI.
> 

That seems straightforward then.

I still wish someone would take a cluebat to Soekris.  We keep hearing
crap like this about their firmware over and over and over again.  It
isn't like you can't get EDK2 or Coreboot and build a BIOS based mostly
on Open Source components these days... oh, wait.

	-hpa

