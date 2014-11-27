Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaK0H7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:59:48 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31525 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaK0H7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:59:47 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-0e-5476d9f091df
Content-transfer-encoding: 8BIT
Message-id: <1417075182.14847.2.camel@AMDC1943>
Subject: Re: [PATCH v2 0/3] regulator: max77686/802: Cleanup
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Thu, 27 Nov 2014 08:59:42 +0100
In-reply-to: <20141126204304.GB7712@sirena.org.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <20141110110022.GX21424@x1> <20141126204304.GB7712@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7ofbpaFGEzeoWuxccZ6VoupD5+w
	WRz9XWBxtukNu8X9r0cZLb5d6WCyuLxrDpvF2iN32S1Od7M6cHr8fX6dxWPnrLvsHptWdbJ5
	3Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mpo3pRUsI6t4uHBm2wNjF9Zuhg5
	OSQETCR2H/rECmGLSVy4t54NxBYSWMoo8fyTNIjNKyAo8WPyPaB6Dg5mAXmJI5eyQcLMAuoS
	k+YtYoYo/8woceSqPES5vsS3iY/A4sICNhJXbnYygthsAsYSm5cvARsvIqAscfX7XqCRXEBz
	HjJJTDq0HqyBRUBV4sW9iWA2p4CRxNJV69hAioQEuhklVr7bxApyhARQd2O/2wRGgVlIzpuF
	cN4sJOctYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESAV93MC49ZnWIUYCDUYmHNyOk
	LESINbGsuDL3EKMEB7OSCK/UIqAQb0piZVVqUX58UWlOavEhRiYOTqkGxqCtTQydv1ZtXjrt
	54fY7ym1+XNfekjZfl0s++9R06QAjQS/q687eT9Lv3J+b2bT3Lf+ZHClsELOinlT94vPywg8
	2bbt50s7521vVRU//WtT8mCQXSPZ13jZeE1Mza1mv7c9E8qaXC6UeHp07/lju+n191Va9vHG
	1yb9ed/50erNgupiQ8ZZGUosxRmJhlrMRcWJAPM45IReAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-11-26 at 20:43 +0000, Mark Brown wrote:
> On Mon, Nov 10, 2014 at 11:00:22AM +0000, Lee Jones wrote:
> > On Wed, 05 Nov 2014, Krzysztof Kozlowski wrote:
> 
> > > Everything should be pulled at once (preferrably regulator tree).
> > > Rebased on next-20141105.
> 
> > I'm happy for that to happen, so long as Mark sends me a tagged commit
> > to pull from.
> 
> The branches for these drivers are getting a bit big and pulling in
> other stuff in the core - it seems like it'd be as easy to just wait
> till after the merge window for the deletion of the old code...

Do you want me to resend the 3rd patch (mfd) after 3.19 merge window?
I've got also some next changes on top of this series (adding GPIO
parsing to regulator core and to the drivers).

Best regards,
Krzysztof


