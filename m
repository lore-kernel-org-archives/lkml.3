Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaELBoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23405 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaELBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:10 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-f3-53702768884c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
 <4764413.ZAEU5S5p0p@wuerfel> <000201cf6a9c$9dd295e0$d977c1a0$%han@samsung.com>
 <6882241.amuhzvbd8n@wuerfel> <536CC0F1.301@ti.com>
In-reply-to: <536CC0F1.301@ti.com>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for
 configuring the iATU
Date: Mon, 12 May 2014 10:44:07 +0900
Message-id: <006501cf6d83$a9f39510$fddabf30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9rfYQyISNCWJM3SyCQ07rYhQEJoQCBYzPg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+ZoW6GekGwwZvHnBZ/Jx1jt5g6eTub
	xZKmDIv5R86xWlxeeInV4sLTHjaLTY+vsVosbFvCYnF51xw2i9lL+lkszs47zmbxpq2R0aLn
	kZbF6741zA58Hr9/TWL0mDfrBIvHgk2lHpuX1Hv0bVnF6HH8xnYmj8+b5ALYo7hsUlJzMstS
	i/TtErgy/s78wVRwWaBi49QpTA2MW3m7GDk5JARMJH60rmGEsMUkLtxbz9bFyMUhJLCMUeJK
	dysrTNG0o/OgEosYJT6/ncEI4fxmlLj84wY7SBWbgJrEly+HwWwRAR2JhafXM4MUMQvMZpZ4
	MPMgK0THYUaJln2fmUCqOAWUJGZe7mEBsYUFEiWOnb0E1s0ioCrxaPUTMJtXwFai8dtfJghb
	UOLH5Htg9cwCWhLrdx5ngrDlJTaveQu0jQPoVnWJR391IY4wkjjz/C4jRImIxL4X78CulhBY
	yiGx5OxRRohdAhLfJh9igeiVldh0gBniZUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0otM9YoTc4tL89L1kvNzNzFCksLEHYz3D1gfYkwGWj+RWUo0OR+YVPJK4g2NzYws
	TE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZG54P3S9HvXPRRm
	T3oktum4rlLKGye54pNNC04Ldma/jBXOapUWsHps6r933vQS9udvdictq1uwfXvCqdN7gx55
	nii/w/eo7ML6d2HLlhz7n8GjFtz8LkvlvLTLG8asuD8OidXmkodeCC508n2/STPw48M2lS1f
	ZQuWTNX9atJQ05bj3GKxs0OJpTgj0VCLuag4EQDXzdL3IAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t9jAd0M9YJgg94lLBZ/Jx1jt5g6eTub
	xZKmDIv5R86xWlxeeInV4sLTHjaLTY+vsVosbAMqu7xrDpvF7CX9LBZn5x1ns3jT1sho0fNI
	y+J13xpmBz6P378mMXrMm3WCxWPBplKPzUvqPfq2rGL0OH5jO5PH501yAexRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAHKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz/s78wVRwWaBi49QpTA2MW3m7GDk5JARMJKYd
	nccGYYtJXLi3Hsjm4hASWMQo8fntDEYI5zejxOUfN9hBqtgE1CS+fDkMZosI6EgsPL2eGaSI
	WWA2s8SDmQdZIToOM0q07PvMBFLFKaAkMfNyDwuILSyQKHHs7CWwbhYBVYlHq5+A2bwCthKN
	3/4yQdiCEj8m3wOrZxbQkli/8zgThC0vsXnNW6BtHEC3qks8+qsLcYSRxJnndxkhSkQk9r14
	xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5xn0jsY
	VzVYHGIU4GBU4uH9wFAQLMSaWFZcmXuIUYKDWUmEdzILUIg3JbGyKrUoP76oNCe1+BBjMtCj
	E5mlRJPzgekwryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY
	HT8stz6w7YwHl48GY881hudxWc/sl7sb7c5/7Px4YoCAqK13/KQJErt2ykrXeH7ibU+dmHU0
	0NhKY1HKxAcTq4Lm8NYlfjnhmPB5VmnFqn1i/f+eRbHazQzQ29sSd/O72tWuli/pR6L0ti5W
	E13KsuvxpdU3GffFNZubLzjX/D1iwp85L1sjlViKMxINtZiLihMBH2Uhun0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 8:50 PM, Kishon Vijay Abraham I wrote:
> On Thursday 08 May 2014 02:48 PM, Arnd Bergmann wrote:
> > On Thursday 08 May 2014 18:05:11 Jingoo Han wrote:
> >> On Tuesday, May 06, 2014 10:59 PM, Arnd Bergmann wrote:
> >>> On Tuesday 06 May 2014 19:03:52 Kishon Vijay Abraham I wrote:
> >>>> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> >>>> address. So whenever the cpu issues a read/write request, the 4 most
> >>>> significant bits are used by L3 to determine the target controller.
> >>>> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> >>>> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> >>>> the outbound translation window the *base* should be programmed as 0x000_0000.
> >>>> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> >>>> we have programmed in the translation window with base as 0x000_0000.
> >>>>
> >>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >>>> Cc: Marek Vasut <marex@denx.de>
> >>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>> Acked-by: Jingoo Han <jg1.han@samsung.com>
> >>>> Acked-by: Mohit Kumar <mohit.kumar@st.com>
> >>>
> >>> Sorry, but NAK.
> >>>
> >>> We have a standard 'dma-ranges' property to handle this, so use it.
> >>>
> >>> See the x-gene PCIe driver patches for an example. Please also talk
> >>> to Santosh about it, as he is implementing generic support for
> >>> parsing dma-ranges in platform devices at the moment.
> >>
> >> Hi Arnd,
> >>
> >> Do you mean the following patch?
> >> http://www.spinics.net/lists/kernel/msg1737725.html
> >>
> >
> > That is the patch Santosh did for platform devices, which is related but not
> > what I meant here. For the PCI inbound window setup, please have a look
> > at https://lkml.org/lkml/2014/3/19/607
> 
> For some reason lkml is not showing any contents. Do you have a different link?

Hi Kishon,

Please refer to the following link. :-)
http://www.spinics.net/lists/linux-pci/msg29855.html


Best regards,
Jingoo Han

