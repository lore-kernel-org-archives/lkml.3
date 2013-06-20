Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab3FTIka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:40:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025Ab3FTIkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:40:16 -0400
X-AuditID: cbfee691-b7fef6d000002d62-f1-51c2bfee4c52
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
 <20130620094835.3f1f34c2@skate> <00c301ce6d8b$d198b210$74ca1630$@samsung.com>
 <20130620100013.6000458f@skate>
In-reply-to: <20130620100013.6000458f@skate>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 17:40:13 +0900
Message-id: <00c901ce6d91$c8382010$58a86030$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKCeiqjUMDl9MJHZtKATS766DS40AIlcxFgArNe7uUC1Vjr5ZeYvPUg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t8zA913+w8FGtw9I2LR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MFqt2/WF0EPJYM28No8fvX5MYPfqmXGXzeLLpIqPH
	zll32T0WbCr1uHNtD5vH5iX1HudnLGT0+L6jF6hqyypGj58vdTw+b5IL4I3isklJzcksSy3S
	t0vgymifeoexYB9nxduVdQ2MK9m7GDk5JARMJBbt/s4MYYtJXLi3nq2LkYtDSGAZo8SnBaeZ
	YIqOzP7BApGYziixY/ZzZgjnF6NEU+s+RpAqNgE1iS9fDoONFRGwkVjVPIcRpIhZ4AKrRHfn
	IyaIjtWMEnsPP2MFqeIU0JFof76HDcQWFoiWeLK4CWwfi4CqxLmbs8BqeAUsJRoOX2WCsAUl
	fky+xwJiMwtoSazfeZwJwpaX2LzmLdQTChI7zr5mhLjCTWJTzzw2iBoRiX0v3oFdJCHwgUNi
	x6wJrBDLBCS+TT4ENJQDKCErsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsYRVML
	kguKk9KLTPWKE3OLS/PS9ZLzczcxQtLOxB2M9w9YH2JMBlo/kVlKNDkfmLbySuINjc2MLExN
	TI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCYf/Px8a/+EyYt8v69
	8v60Pv9IQdcy0az7KTxrr8w9ePCJi/sfFQfOc7PEXitP2rS4MNdj6TLLuNb+6975vy27tp08
	kLFQ7U2QwCz/EjORorxZGrney5nD+Rb37p+y/82Tdy902vcVXd1es0r+ytcTE1asTjRPtONd
	4yn259reQ4WRzkWJHyt2K7EUZyQaajEXFScCAAmPT69RAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsVy+t9jQd13+w8FGnR857No/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmi1W7/jA6CHmsmbeG0eP3r0mMHn1TrrJ5PNl0kdFj
	56y77B4LNpV63Lm2h81j85J6j/MzFjJ6fN/RC1S1ZRWjx8+XOh6fN8kF8EY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xon3qHsWAfZ8XblXUNjCvZuxg5OSQETCSOzP7B
	AmGLSVy4t56ti5GLQ0hgOqPEjtnPmSGcX4wSTa37GEGq2ATUJL58OQzWLSJgI7GqeQ4jSBGz
	wAVWie7OR0wQHasZJfYefsYKUsUpoCPR/nwPG4gtLBAt8WRxExOIzSKgKnHu5iywGl4BS4mG
	w1eZIGxBiR+T74HdxCygJbF+53EmCFteYvOat8wQtypI7Dj7mhHiCjeJTT3z2CBqRCT2vXjH
	OIFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQntWdSOxhX
	NlgcYhTgYFTi4dW4fDBQiDWxrLgy9xCjBAezkghv6pxDgUK8KYmVValF+fFFpTmpxYcYk4E+
	ncgsJZqcD0y4eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	aLLezCFlm0tVbcZ8T4fs9lbZpbyJmZ7339/g6ambzX62YMd0tjn8m4TuHptblf77zVWt3BO/
	NqxQLvKfGOR8mOH0XtdrIcsePs9fWFeysD7P/tYbNs0cbbF1xo2z+vru85xPasg88j9FMHdW
	/onDbzl+zv7K9t2xlvtgl4q38rV1i2891Z4orMRSnJFoqMVcVJwIANzQEpKuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 5:00 PM, Thomas Petazzoni wrote:
> 
> Dear Jingoo Han,
> 
> On Thu, 20 Jun 2013 16:57:32 +0900, Jingoo Han wrote:
> 
> > > > -	pinctrl {
> > > > +	pin_ctrl: pinctrl {
> > > >  		compatible = "samsung,exynos5440-pinctrl";
> > >
> > > I know I'm nitpicking, but isn't this change completely unrelated to
> > > PCIe support?
> >
> > This change is related to PCIe support.
> > Without this, I cannot use gpio binding.
> >
> > This change was guided by Thomas Abraham (Author of Samsung pinctrl).
> > Also, it was confirmed by Kukjin Kim (Maintainer of Samsung SoC).
> >
> > Thank you for your caring. :)
> 
> I mean, the change is fine for sure, but it should maybe part of a
> separate patch as it is more a fix than really the introduction of the
> PCIe controller node, as the patch title suggests. This would also for
> example allow this fix to be merged right now (for 3.11), regardless of
> what happens for the rest of your PCIe patches.
> 
CC'ed Tomasz Figa


OK, I see.
I will separate this patch to two patches, as Tomasz Figa mentioned.
(http://www.spinics.net/lists/linux-samsung-soc/msg19639.html)
Thank you.


Best regards,
Jingoo Han

