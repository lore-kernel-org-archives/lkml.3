Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaF3D0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:26:05 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35400 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaF3D0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <53AD625B.1080002@cogentembedded.com>
References: <6233f866-678d-4a90-a307-debcb848ae76@BN1AFFO11FD023.protection.gbl>
	<53AD625B.1080002@cogentembedded.com>
Date: Mon, 30 Jun 2014 08:56:00 +0530
X-Google-Sender-Auth: N5WJJkJEqZTCiYNFpSGg-79Qr0Y
Message-ID: <CAGnW=BZ7_SO3E3q23HSViBksEwp=BPWq5SXTROA3VJuYMBeDWQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] usb: chipidea: zynq: Add device tree binding information
From: punnaiah choudary kalluri <punnaia@xilinx.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Peter Chen <Peter.Chen@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, rdunlap@infradead.org,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Punnaiah Choudary <kpc528@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 5:53 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 06/27/2014 03:23 PM, Punnaiah Choudary Kalluri wrote:
>
>> Document device tree binding information as required by
>> the ZYNQ USB controller.
>
>
>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>
> [...]
>
>
>> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
>> b/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
>> new file mode 100644
>> index 0000000..54bb3b4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
>> @@ -0,0 +1,23 @@
>> +Xilinx Zynq usb controller based on synopsys usb IP(v2.20a)
>
>
>    s/usb/USB/.

OK

>
>
>> +
>> +Required properties:
>> +- compatible:   should contain "xlnx,zynq-usb-2.20a"
>> +- clocks:       clock provider specifier
>> +- reg:          offset and length of the register set in the memory map
>> +- interrupt-parent: the phandle for the interrupt controller that
>> services
>> +                    interrupts for this device.
>
>
>    This property has never been required -- it can be inherited from the
> upper level node.

OK. i will correct it.

Thanks,
Punnaiah

>
> WBR, Sergei
>
>
