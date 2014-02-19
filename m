Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaBSQnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:43:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56795 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbaBSQnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:43:18 -0500
Message-ID: <5304DDD7.9070009@zytor.com>
Date: Wed, 19 Feb 2014 08:37:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: carl peng <carlpeng008@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, x86@kernel.org, pingfank@linux.vnet.ibm.com,
        yoshihiro.yunomae.ez@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: Does it need to implement irq_set_type method in the ioapic_chip?
References: <CAC5e1FoLrHWSa_7BnRt-u451ZJOVqKhSpbyp8O_ExDbgcXtU+g@mail.gmail.com>	<alpine.DEB.2.02.1402182101450.4468@ionos.tec.linutronix.de> <CAC5e1FpChdyW9xzbwsyVx147hKrV0MxwkCMyKHR4ab5-Q=DyPg@mail.gmail.com>
In-Reply-To: <CAC5e1FpChdyW9xzbwsyVx147hKrV0MxwkCMyKHR4ab5-Q=DyPg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 06:32 PM, carl peng wrote:
> 1) This device is a ACPI device, the hardware engineer designed it as
> falling edge interrupt trigger
> mode, does it need to re-work the hardware and modify it as rising
> edge trigger mode to suit the
> Linux APIC driver architecture?

Could you share what the ACPI description of your device looks like?

	-hpa


