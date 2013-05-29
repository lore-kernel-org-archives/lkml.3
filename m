Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406Ab3E2JbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:31:00 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:17897
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965201Ab3E2Ja7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:30:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <51A5CAC1.6030800@freescale.com>
Date: Wed, 29 May 2013 17:30:41 +0800
From: Chen Yuanquan-B41889 <B41889@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 01:35 AM, Guenter Roeck wrote:
> bios_add_device(). Drop explicit calls to pcibios_setup_device();
> this makes pcibios_setup_bus_devices() a noop function which could
> eve

Yeah, it's more reasonable to do the irq and DMA related initialization
in one code path for all devices.

Regards,
Yuanquan


