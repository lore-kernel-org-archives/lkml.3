Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaK0K7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:59:13 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8906 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaK0K7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:59:11 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a3-547703fe6a6f
Message-id: <1417085948.22343.1.camel@AMDC1943>
Subject: Re: [PATCH v2 0/3] regulator: max77686/802: Cleanup
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Thu, 27 Nov 2014 11:59:08 +0100
In-reply-to: <20141127105411.GD7712@sirena.org.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <20141110110022.GX21424@x1> <20141126204304.GB7712@sirena.org.uk>
 <1417075182.14847.2.camel@AMDC1943> <20141127105411.GD7712@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7r/mMtDDFbtErXYOGM9q8XUh0/Y
	LI7+LrA42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Banu1kdOD3+Pr/O4rFz1l12j02rOtk8
	7lzbw+Yx72SgR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGWsX9XNWrCWpWLNh0OMDYwbmbsY
	OTkkBEwk1u68yARhi0lcuLeerYuRi0NIYCmjxPM/f5ggnM+MErfvT2YDqeIV0JeYM6mbBcQW
	FrCRuHKzkxHEZhMwlti8fAlYjYiAssTV73tZQJqZBR4ySUw6tB5sHYuAqsSEeUvB1nEKGEn8
	OTwVat11RokvHfNZQRLMAuoSk+YtAmrgALpJWaKx3w1isaDEj8n3WCBK5CU2r3nLPIFRYBaS
	jllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyQWvu5gXHrM6hCjAAejEg8v
	w62yECHWxLLiytxDjBIczEoivFyM5SFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGO8Ihk6SteZa
	r9y7juVLvPEi/0qGDzxMsxPXHwso/uP09l9LWWf6qzkCdlyMrzfOueQiUlv4UlBvz405S3/L
	6styLhCZYt753VIr20bb+FZS0Zx6P9Y3b4/tifDoz37Mqce1ZX5k0l3zU/9P2d4/+eAFwwoH
	uymcu2cvjZbNqD906cajM4IHO5VYijMSDbWYi4oTARz74dRjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 10:54 +0000, Mark Brown wrote:
> On Thu, Nov 27, 2014 at 08:59:42AM +0100, Krzysztof Kozlowski wrote:
> 
> > Do you want me to resend the 3rd patch (mfd) after 3.19 merge window?
> > I've got also some next changes on top of this series (adding GPIO
> > parsing to regulator core and to the drivers).
> 
> That would seem to make sense.  If you're adding support for things to
> the core you should probably be sending patches sooner rather than
> later...

OK, I'll send them to get your feedback.

Thanks,
Krzysztof

