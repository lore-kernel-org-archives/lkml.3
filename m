Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaE0Grw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:47:52 -0400
Received: from mail.southpole.se ([37.247.8.11]:51315 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaE0Grv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:47:51 -0400
Message-ID: <53843508.7060007@southpole.se>
Date: Tue, 27 May 2014 08:47:36 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux <linux@openrisc.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] openrisc: irq: use irqchip framework
References: <1401136302-27654-1-git-send-email-stefan.kristiansson@saunalahti.fi> <CAMuHMdUUqaRP2M0hPh5k0nPp1a_t0W98Vc_4zAQMjGYZZOPd8w@mail.gmail.com>
In-Reply-To: <CAMuHMdUUqaRP2M0hPh5k0nPp1a_t0W98Vc_4zAQMjGYZZOPd8w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.4.1(14132) on assp.southpole.se
X-Assp-ID: assp.southpole.se 73251-13799
X-Assp-Session: 7F61235C55C8 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 10:52 PM, Geert Uytterhoeven wrote:
> CC devicetree for the bindings
> 
> On Mon, May 26, 2014 at 10:31 PM, Stefan Kristiansson
> <stefan.kristiansson@saunalahti.fi> wrote:
>> +++ b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
>> @@ -0,0 +1,23 @@
>> +OpenRISC 1000 Programmable Interrupt Controller
>> +
>> +Required properties:
>> +
>> +- compatible : should be "opencores,or1k-pic-level" for variants with
>> +  level triggered interrupt lines, "opencores,or1k-pic-edge" for variants with
>> +  edge triggered interrupt lines or "opencores,or1200-pic" for machines
>> +  with the non-spec compliant or1200 type implementation.
>> +
>> +  "opencores,or1k-pic" is also provided as an alias to "opencores,or1200-pic",
>> +  but this is only for backwards compatibility.

I still think this identifier needs to be versioned.  Use the same
version number as we have on the cpu identifier since the OR1200 PIC
hasn't changed since then; i.e. opencores,or1200-pic-rtlsvnXYZ.

/Jonas


