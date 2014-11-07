Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaKGIHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:07:33 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52224 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGIHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:07:32 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-50-545c7dc2be8a
Content-transfer-encoding: 8BIT
Message-id: <1415347649.8532.8.camel@AMDC1943>
Subject: Re: [PATCH v2 3/3] mfd: max77686/802: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 07 Nov 2014 09:07:29 +0100
In-reply-to: <545C01FF.3090101@collabora.co.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <1415180871-25293-4-git-send-email-k.kozlowski@samsung.com>
 <545C01FF.3090101@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xq7qHamNCDNbN0rDYOGM9q8XUh0/Y
	LI7+LrA42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Banu1kdOD3+Pr/O4rFz1l12j02rOtk8
	7lzbw+Yx72SgR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGWsWLKBqeAES8WCRydYGxjvMHcx
	cnJICJhI7D/1jQnCFpO4cG89WxcjF4eQwFJGiTtLjrKBJHgFBCV+TL7H0sXIwcEsIC9x5FI2
	SJhZQF1i0rxFYHOEBD4zSjx/IQdRrifx8NN3VhBbWMBX4umfLYwgNpuAscTm5UvARooI2Enc
	WP2QGWQXs8ARJok937tYQBIsAqoSOye8BBvKKaAvcfzLUSaIg1YxSvydeJYZ5AgJAWWJxn63
	CYwCs5CcNwvhvFlIzlvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyQKvu5gXHrM6hCj
	AAejEg/vA5GYECHWxLLiytxDjBIczEoivFJBQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MV4PF
	WTwmCcbGbDXYWP6VPczw98d1Jm33N1nP7V7fppyR6cg/6+ynOQVNF9KSPKRuOVqu9hB++ZDl
	d8yuefy+Ky7N1sqdKqbOmZz5S+0tX0vMh6PyFU8PVjyN6PXfrvXr2ey/PXyXw1mUNopcirzn
	pG/kOnFLxsJe3rXtp7S2K2fUV8//yianxFKckWioxVxUnAgAAenozmACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-07 at 00:19 +0100, Javier Martinez Canillas wrote:
> On 11/05/2014 10:47 AM, Krzysztof Kozlowski wrote:
> > The driver is used only on Exynos based boards with DTS support.
> > After removal of board file support from max77686 and max77802 regulator
> > drivers, the MFD driver can be converted to DTS-only version. This
> > simplifies a little the code:
> 
> Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 

Thanks very much!
Best regards,
Krzysztof



