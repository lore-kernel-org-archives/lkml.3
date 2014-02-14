Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaBNRrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:47:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56218 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaBNRrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:47:10 -0500
Message-ID: <52FE5683.6030708@zytor.com>
Date: Fri, 14 Feb 2014 09:46:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com>
In-Reply-To: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 02:23 AM, Conrad Kostecki wrote:
> Hello,
> as the Soekris net6501 does not have any ACPI implementation, HPET won't get enabled.
> This patch enables HPET on such platforms.
> 
> [    0.430149] pci 0000:00:01.0: Force enabled HPET at 0xfed00000
> [    0.644838] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> 
> Original patch by Peter Neubauer, slightly modified by me.
> -> http://www.mail-archive.com/soekris-tech@lists.soekris.com/msg06462.html
> 
> Cheers
> Conrad

Are you sure this won't break any other E6xx platforms?

	-hpa

