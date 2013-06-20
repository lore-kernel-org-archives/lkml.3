Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3FTH5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:57:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12991 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3FTH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:57:34 -0400
X-AuditID: cbfee691-b7fef6d000002d62-27-51c2b5ec7c86
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
        Jingoo Han <jg1.han@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
 <20130620094835.3f1f34c2@skate>
In-reply-to: <20130620094835.3f1f34c2@skate>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 16:57:32 +0900
Message-id: <00c301ce6d8b$d198b210$74ca1630$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKCeiqjUMDl9MJHZtKATS766DS40AIlcxFgl8T2XFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t8zY923Ww8FGsxexGTR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnissmJTUnsyy1SN8ugSvjQ/te5oK1
	bBWtS3eyNDD+Yeli5OSQEDCR6Ph+iwnCFpO4cG89WxcjF4eQwDJGiVetzawwRbeOwiQWMUoc
	PzSBHcL5BVR1pIERpIpNQE3iy5fD7CC2iICNxKrmOYwgRcwCy1klbjztZAZJCAlES/z5/hRs
	H6eAjsSWyzfA4sJA8SeLm8DiLAKqEg8X/wUbxCtgKfHl2lc2CFtQ4sfke2B3MwtoSazfeZwJ
	wpaX2LzmLTPEqQoSO86+ZoQ4wkri3LpPbBA1IhL7XrwDO0hC4AGHxI4rXVDLBCS+TT4ENJQD
	KCErsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLTPWKE3OLS/PS
	9ZLzczcxQlLMxB2M9w9YH2JMBlo/kVlKNDkfmKLySuINjc2MLExNTI2NzC3NSBNWEudVb7EO
	FBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoVP7JuNK1fibn+W3f571tmNE8e/IMceezu7u0
	pK7u2RC4ZEtt/57tp2SXPY4os23LXsf64eXaM9lXik7vY0qO87+2XsWJd0tA9yfx4lN6611e
	8zT8vJ8Q6vmh5VvxFIHtpzPWWPJ1irn06nGq2Ibvff3902Wezr/ycoycAU6nnzIsys48w/RB
	iaU4I9FQi7moOBEAGoeTOUcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsVy+t9jAd03Ww8FGny5b2nR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoLyWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxof2vcwFa9kqWpfuZGlg/MPSxcjJISFgInHr6Ho2CFtM4sI9EJuL
	Q0hgEaPE8UMT2CGcX4wSr440MIJUsQmoSXz5cpgdxBYRsJFY1TyHEaSIWWA5q8SNp53MIAkh
	gWiJP9+fMoHYnAI6Elsu3wCLCwPFnyxuAouzCKhKPFz8F2wQr4ClxJdrX9kgbEGJH5PvgZ3H
	LKAlsX7ncSYIW15i85q3zBCnKkjsOPuaEeIIK4lz6z6xQdSISOx78Y5xAqPQLCSjZiEZNQvJ
	qFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE5gz6R3MK5qsDjEKMDBqMTDq3H5
	YKAQa2JZcWXuIUYJDmYlEd7UOYcChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmFzzSuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHRjWs5V2t5/7ZD91c5
	da3/7vdWcPaD9Uw1TBM/nJny8uLiBJuD22/xdfAuDsw1OLBsHbf7Y80Hm2ZGPirg2Pn6zLWw
	a8WzW8/93PYte+9jqfDjzxdP8Pmit1dQuNjw+le9bxvN7GK1+rWzemdmSt4J/xPLPI0n4UQF
	h9kZa+GPB3c42jyQfCeVq8RSnJFoqMVcVJwIAI1N0WGkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 4:49 PM, Thomas Petazzoni wrote:
> 
> Dear Jingoo Han,
> 
> On Thu, 20 Jun 2013 16:12:24 +0900, Jingoo Han wrote:
> 
> > -	pinctrl {
> > +	pin_ctrl: pinctrl {
> >  		compatible = "samsung,exynos5440-pinctrl";
> 
> I know I'm nitpicking, but isn't this change completely unrelated to
> PCIe support?

This change is related to PCIe support.
Without this, I cannot use gpio binding.

This change was guided by Thomas Abraham (Author of Samsung pinctrl).
Also, it was confirmed by Kukjin Kim (Maintainer of Samsung SoC).

Thank you for your caring. :)

Best regards,
Jingoo Han

> 
> Thomas
> --
> Thomas Petazzoni, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com

