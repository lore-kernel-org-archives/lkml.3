Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLRE6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:58:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13276 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaLRE6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:58:30 -0500
X-AuditID: cbfee68f-f791c6d000004834-b8-54925ef20f1f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Gabriel FERNANDEZ'" <gabriel.fernandez@st.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Srinivas Kandagatla'" <srinivas.kandagatla@gmail.com>,
        "'Maxime Coquelin'" <maxime.coquelin@st.com>,
        "'Patrice Chotard'" <patrice.chotard@st.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Gabriel Fernandez'" <gabriel.fernandez@linaro.org>,
        "'Fabrice Gasnier'" <fabrice.gasnier@st.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Thierry Reding'" <treding@nvidia.com>,
        "'Minghuan Lian'" <Minghuan.Lian@freescale.com>,
        "'Magnus Damm'" <damm@opensource.se>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Murali Karicheri'" <m-karicheri2@ti.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Sachin Kamat'" <sachin.kamat@samsung.com>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Srikanth Thokala'" <sthokal@xilinx.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-pci@vger.kernel.org,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
 <1418812486-12394-5-git-send-email-gabriel.fernandez@linaro.org>
 <1507589.aeTeyNn1QF@wuerfel>
In-reply-to: <1507589.aeTeyNn1QF@wuerfel>
Subject: Re: [PATCH 4/5] PCI: designware: Add setup bus-related to pcie_host_ops
Date: Thu, 18 Dec 2014 13:58:27 +0900
Message-id: <000e01d01a7f$47592e20$d60b8a60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAaRx55IUS/BKgARRqsfh0+Sm9xQwAN2NpQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTaRCG851bD401ZxH0sypoFV0NsHJ1jJcY448vm5hAQE2MKVT2BMxC
	bVogbrJRgli8AEW8NGkEbRQFUq0UQ4qLS62IXAS1oLKLSASVdaPuykUqCAo9mvDvmcnMvO9M
	hqf9Czglv0+bKeq1mnQVJ2dsAdHGsGF1SeLay0HwoNdNw2RJkwwu5abBG/dq6Bv4m4LzjR0s
	mK8MUlBhdbGQ13efAtNbKwuuz04EHf9WIui0elj4v7uJhYevCjjoG72LwDHwhIXOm+c4aC+7
	x0FPpwJc5fkMFBW6OCh/+oiC/raLHLx+dYSG6jPjCM41P0ZQbL7KQL5nORy51SiDLk8rB8aP
	aii122gYHBpioGdiLlSPEnjzoZnZEkI+2IcQsZXZEMk7XMCRifESRDqLCikydcdEkTpLr4xc
	cGSRyisjHHFUHePIsyf1HKm5dIjUOYcpUnj4PUcqvR4ZKbpRheICd8s3/iKm78sW9T9tTpan
	dT3toXTt/AG7a0CWg15wx5Efj4VoPFnRREs8Hz98bp/Oy3l/oRzhyqbTzHHE+4qOOROkvBlh
	e6sRScE4wjWttb5JnLASj4zckc1wgBCJH7x95ptEC1/keKrfzEod1xAeKyzwdfgJq/GJv5w+
	nifE4YYvL6kZZoQQ3O6t83lSCJvwbe8gJfEP2HvqOTPDtLAG19TmshIH4xrbO1qyugr3T4Z9
	N9FclEdJJQH4z3/e+1xjIVeOS//7g5a0BPzxlPvbmkuww/XtFAvx7Ypuphhhyyxlyyxlyyxl
	yyyJC4ipQoGiLkVn2Juqjwo3aDIMWdrU8JT9GQ40/aRtU69NTtTr2uBGAo9UcxQ4vCTRn9Vk
	G37LcKOYaUcnaWVgyv7pv9ZmJkVExUZCTHRMVOS69bGqBQqr8lOCv5CqyRR/FUWdqE/SZ6WL
	BjeieD9lDjLE1d5Y5km+lfZzUpB1jF88r1rWfFcVfbmUsjUmepOXRXTFH8wO3WVcvDN0IupR
	fvzFBtOi3+tb1MqKyXeu0Yy2PatCdcGN21a8DOsoa6mzt+zBatvphTnG8/XicORZRfmPcaPF
	1xXxC2LdQY+XHp2vbjCNbd+7NbgbWs07nENap4oxpGki1tB6g+YrJ98brJ8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA2WTbUxTVxjHc+7Laal2uXYwz/iwkeuY0aRIK8JDNtzY0NxEnUS7hSwZ3V25
	Aba+pbd10y9rFHEwilqzsFRlEjWuBG2AhZSFza6oIyCKvA5RyOgENc5MhtrhxLU0LGQ7n37n
	yfP75zkn5yhpzQhOVZZbnZLDKpp5rGJ65iMrtDPFXkPmydvr4erNMA1PvZcUcGpvGdwJr4GJ
	yHUKvrlwhYW6M9MUfNsQYqFi4jIFB+81sBD6O4jgyl0/goGGfhb++OUSC323ajBMPLyIoCUy
	zMLA98cw9Nb/jGFsQA2h0wcYqPWEMJweuUbBZM9JDFO39tPQ/NUcgmNdQwgO1Z1l4ED/Ktj/
	wwUFDPZ3Y6h8VAzHA000TM/MMDD25DlofijAnQddzJvpwoPADBKa6puQULGvBgtP5rxIGKj1
	UMJ850FKaPfdVAgnWlyC/8wsFloaq7BwY7gDC62nPhfag39SgmfffSz4o/0Kofa7RlSY8r4b
	vV4miSWSI02ymmwl5dbSPH7LTuPbxg3ZmTqtLhdy+DSraJHy+IKthdrN5ebYZfJpu0SzK1Yq
	FGWZX7fx/wnvGjZrYVEs0m4z7PjX0Wf+Z314DpUNjoxR9l7lZ4FQROFGv+JqpFQSLotUBXdW
	o6QYvkD6xgOxskqp4eoQCXRXosRmDpHW7jYc78Lcq2R2tlMR52ROT67eu7Fg0NwzFZmfrGMT
	xjlEHntqFowkbg35cjS4wM9zheT8s9+oODNcOumNttNxVnN55KfoNJXgFSR6ZJyJM82tJa1t
	e9kEv0xam36nE2OvJpNPtYtDdNVWUImWZPLj7fvoENL4liT5liT5liT5lignENOIUiS7yS5/
	VGrRZciiRXZZSzNMNksLWnjUU6lB5HdDGHFKxC9XkwyvQcOKu+TdljAiSppPVnNFsZK6RNy9
	R3LYjA6XWZLDaEPsoIfp1BSTLfZFrE6jbn1Wtj5Xnw36rJwcfqWaf6PSoOFKRaf0iSTZJcei
	RymTUt2oa1POS9fG3rvYZ+9QBOZU6Vun3UMFy/L914fvllRY2rrp1/LnVUeWVb5lP/pp8ZSt
	YPtws5lm80edxXuShlzVj8/jmtlXAusmH/21LTJI8vLrP7D0dOCPoy9W6xuqtmdLlz3N9i9W
	b9nUWTRuPPpOrsm1PPkwXjXq3ZjiRF+HVhbxjFwm6tbSDln8B1ZCa8HqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 7:16 AM, Arnd Bergmann wrote:
> On Wednesday 17 December 2014 11:34:45 Gabriel FERNANDEZ wrote:
> > ST sti SoCs PCIe IPs are built around DesignWare IP Core.
> > But in these SoCs PCIe IP doesn't support IO.

Hi Gabriel,

I cannot understand how ST sti SoCs PCIe IP does not support I/O.
As far as I know, it cannot be selected by the 'parameter'.
Then, H/W engineers dropped out the I/O control logic?

> >
> > To support this, add setup_bus() to pcie_host_ops.


> >
> > Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> > Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> 
> The dw-pcie driver should be able to tell whether the device has
> an I/O space or not, and do the right thing based on that. Don't
> add an implementation specific callback for that.

I agree with Arnd's opinion.

In addition, I have one more question.
Then, if a device that requires I/O region is connected to
PCIe slot of ST sti SoCs PCIe, what will happen?
It just prints error messages?

Best regards,
Jingoo Han

> 
> 	Arnd

