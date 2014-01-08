Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbaAHKJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:09:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbaAHKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:09:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Feng Kan <fkan@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot dts node.
Date: Wed, 08 Jan 2014 11:08:33 +0100
Message-ID: <6073715.cGydpIHKD1@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140108100549.GE6701@e106331-lin.cambridge.arm.com>
References: <1389135041-16062-1-git-send-email-fkan@apm.com> <1389135041-16062-2-git-send-email-fkan@apm.com> <20140108100549.GE6701@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:84CdpUjtdVLmls3sgCVL3wi9y10Ubwg4xDVJjCMgtFh
 er3z+ht+TVidL1A502noK9D+17a8Q8ptcsXoNPzwv3VUuYUgCJ
 QA+P8doiLSt+YNbn5gXh9KIP03XoNvTFg42B5LTLtJMQI1q0x8
 ehhUq299EdS/ENCfmlppzdBlaSS+1+dVCLoQCCLHoXPg383RwM
 42GdPjqgmB2URcRywiq8HrhbpKKColkcjXoCJ3LDCPceBXNB88
 dFHSmk8QFBeQN0zCEs+nh41dOw8uj8tmuMAqftg0XiqCrX72rz
 wOijKGlRbnyz4/hvolb7IeCs1/tKVnR+3Y5xO+jD/YtS8qHNOI
 TOMVN+vpKu6jmBZqQYWg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 10:05:50 Mark Rutland wrote:
> > +
> > +Example:
> > +
> > +     reboot@0 {
> > +             compatible = "apm,xgene-reboot";
> > +             reg = <0x0 0x17000014 0x0 0x4>;
> > +     };
> 
> Given this seems to be a 64-bit address, the unit address should
> preferably be 0,17000014 rather than just 0.

I also wonder about the size and location of the register.
Are you sure the device is just a single 4-byte register at offset
0x14, rather than a complex device that happens to contain the
reset register?

	Arnd
