Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaKEIeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:34:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20716 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaKEIeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:34:18 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-19-5459e107050b
Message-id: <1415176454.15850.6.camel@AMDC1943>
Subject: Re: [PATCH 0/6] regulator: max77686/802: Cleanup
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Wed, 05 Nov 2014 09:34:14 +0100
In-reply-to: <20141104204234.GD3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415093122.2389.15.camel@AMDC1943> <20141104204234.GD3815@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xq7rsDyNDDD7dMbTYOGM9q8XUh0/Y
	LI7+LrA42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Banu1kdOD3+Pr/O4rFz1l12j02rOtk8
	7lzbw+Yx72SgR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVsbTzHXrCYpWLp9r2MDYxrmLsY
	OTkkBEwkHlxth7LFJC7cW8/WxcjFISSwlFHi85oHTCAJIYHPjBI/7/GC2LwC+hIHH1wBaxAW
	sJR4u7+ZBcRmEzCW2Lx8CRuILSKgLHH1+16wOLPAQyaJB5tqQWwWAVWJpU9+MoLYnAJGEvff
	7GWHWDaZUeLxjm5miAZ1iUnzFgHZHEAXKUs09rtB7BWU+DH5HtRMeYnNa94yT2AUmIWkYxaS
	sllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImDLzsYFx+zOsQowMGoxMPr0RQZ
	IsSaWFZcmXuIUYKDWUmEl/MSUIg3JbGyKrUoP76oNCe1+BAjEwenVANjlrreOV4vue62f+bL
	4hckXOE6rnzhyLbfL2u1Ui6GWnxIW54RzMZ9u66zYIeKT0eznuSzLcptkv4K6bw7BDffKpmT
	e+/7jNrtUt52xtc3vPAL1tULUfILW96bzqbquGuWaHfaHzaNl6v+XFa+yZf05crMNnVdgZzf
	P9nDj+S1r9z9OuZmkqwSS3FGoqEWc1FxIgA1AVtUYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 20:42 +0000, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 10:25:22AM +0100, Krzysztof Kozlowski wrote:
> 
> > Probably I should rebase it on newer next or regulator tree because
> > yesterdays Javier's changes were applied. The merge conflict is trivial
> > to solve (only removal of lines).
> 
> > Mark, let me know if you want me to resubmit because of the conflict.
> 
> Send me something I can apply, please.

Thanks for applying first three patches. I'll send rebased version.

Best regards,
Krzysztof


