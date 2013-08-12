Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3HLRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:48:33 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:62552 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3HLRsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130812164548.GE23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130812164548.GE23006@n2100.arm.linux.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 12 Aug 2013 18:48:09 +0100
Message-ID: <CAFEAcA_=TKdvonBaVUSdSn=-ncXRxJN6DsROU+_2UJuCk-bvsA@mail.gmail.com>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 17:45, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> In other words, if you have the circuit diagrams or other documentation
> which definitively identifies the wiring, then please send it to me.

I've just checked and the schematics are provided on the CDROM
"Versatile Family Product Support CD" (version 3.0) which I
think we shipped a copy of with every board...

-- PMM
