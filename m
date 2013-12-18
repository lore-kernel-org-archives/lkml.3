Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3LROD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:03:58 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12632 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LROD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:03:56 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-39-52b1ab4961c7
Message-id: <1387375431.1433.2.camel@AMDC1943>
Subject: Re: [PATCH 3/5] mfd: sec: Remove sec_reg* regmap helpers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Wed, 18 Dec 2013 15:03:51 +0100
In-reply-to: <20131218133625.GT28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-4-git-send-email-k.kozlowski@samsung.com>
 <20131218133625.GT28455@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xy7qeqzcGGUy6z2/RcDXEYurDJ2wW
	84+cY7Xof7OQ1eLAnx2MFuderWS0ONv0ht3i/tejjBbfrnQwWSxsW8JicXnXHDaLtUfuslss
	vX6RyWLC9LUsFodXHGCyWPdyOovFyT+9jBanu1ktLq74wmRxbMYSRgcRjzXz1jB6LPh8hd3j
	cl8vk8fOWXfZPVYu/8LmsWlVJ5vHq9UzWT3uXNvD5jHvZKBH35ZVjB6fN8kFcEdx2aSk5mSW
	pRbp2yVwZSxasJK5YCNrReOPT0wNjEtZuhg5OSQETCReLp3HDGGLSVy4t56ti5GLQ0hgKaPE
	14t3oJzPjBIXt89kAqniFdCTmH/gNFi3sICjxOel+8DibALGEpuXL2EDsUUElCWuft/LAtLM
	LPCAVaL92CWgFRwcLAKqErfWFYCYnED1Ux55g5QLCaxjlPi1MBXEZhZQl5g0bxHUQUoSu9s7
	2SHi8hKb17xlhjhBUOLH5HssExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQqLz6w7GpcesDjEKcDAq8fAu8NkYJMSaWFZcmXuIUYKDWUmEd+EMoBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbG6cyz5t/M4ZbdfirYQ3ti5EOF9/XuK3zN9h/Zn9YcFmsisf7HHjmJ
	1427UsvK1q26W9PzICI3zEqzvn4++5y9EgJyofrt06OW5dQe1Ot1d3ve/vDgo+Rd936+XfhD
	uKr2R0x1c7hNSR4/z7E379x/hTB0LZDxLWw6e+XKHEvFZwYpQSnfvgQqsRRnJBpqMRcVJwIA
	vd6x7qwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 13:36 +0000, Mark Brown wrote:
> On Tue, Dec 17, 2013 at 02:23:19PM +0100, Krzysztof Kozlowski wrote:
> > Remove sec_reg* helpers as they are not used anymore. These helpers were
> > error-prone as they mixed u8 with unsigned int and they changed order of
> > some of parameters (val and mask in sec_reg_update()).
> 
> This doesn't apply against the regulator tree.  Can you please check
> what's going on here, I guess there may need to be some merge with MFD?

I think you need to rebase on current Linus' (at least 3.13-rc4) to get
this patch:
"mfd/rtc: s5m: fix register updating by adding regmap for RTC" (3e1e4a5f3a3)

Best regards,
Krzysztof

