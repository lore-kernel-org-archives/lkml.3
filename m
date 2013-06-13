Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3FMXCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:02:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42727 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3FMXCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:02:51 -0400
X-AuditID: cbfee68e-b7f276d000002279-87-51ba4f9aa8cb
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
 <1552010.DOo3aEBKyJ@flatron> <15cf01ce6884$8c073f20$a415bd60$%kim@samsung.com>
 <26381641.c4KnMQ8aS6@flatron>
In-reply-to: 
Subject: RE: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Fri, 14 Jun 2013 08:02:50 +0900
Message-id: <15e301ce688a$20acbc90$620635b0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5oheMTf4uTo/GYQ1GY7KQt9NBqHAAAiFXQAAB7R4A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t8zI91Z/rsCDf5dVrSYs34Nm8Wsa0EW
	c863sFicXXaQzWLJz11MFr0LrrJZTPmznMni8q45bBYzzu9jsthz9DC7xanrn9kstu69ym5x
	bMYSRotVu/4wOvB5NN64weZx5PYMZo/ZDRdZPKb83sjqsWXlTSaPnbPusnvcubaHzePEjN8s
	HldONLF6vN93lc2jb8sqRo/Pm+QCeKK4bFJSczLLUov07RK4Mv5c/M5e8JK5Ytmtc4wNjC+Z
	uhg5OSQETCTWPHvHCGGLSVy4t56ti5GLQ0hgGaNE+8QJbDBFj76vZ4VILGKUOPvtHlTVX0aJ
	7fcngLWzCWhIHH7/jB3EFhHwlzi5bgk7SBGzwHQWiRfTT7FAdGxjlJgyexszSBWnAI/Euj+d
	QDYHh7CArcTbvX4gYRYBVYn+bd/A7uMFCu950McKYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnN
	W7AxEgLqEo/+6kLcYCXxfgvEJmYBEYl9L0De5AIqucIh0ff4IRPELgGJb5MPsUD0ykpsOsAM
	8bGkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsY
	IamkbwfjzQPWhxiTgdZPZJYSTc4HpqK8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTBGybbOaXrZ+95EcI7SJend+fv+CG+UE9wRvyja8Cj/bqda
	MQlGw9ipy1b9u7NLTfe63afI9Oylld93ve0pUzs2S/ry1pZztVwrrFUm+pUufCO9eann1vC6
	NAau7Z53XS4bW+ziF7lzNSzq2FMfJ77i35ZdL3Mv8Szd9WLVN1fx7m88Vo9NcuyVWIozEg21
	mIuKEwFuwZx7OwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xgO4s/12BBt3bZCzmrF/DZjHrWpDF
	nPMtLBZnlx1ks1jycxeTRe+Cq2wWU/4sZ7K4vGsOm8WM8/uYLPYcPcxucer6ZzaLrXuvslsc
	m7GE0WLVrj+MDnwejTdusHkcuT2D2WN2w0UWjym/N7J6bFl5k8lj56y77B53ru1h8zgx4zeL
	x5UTTawe7/ddZfPo27KK0ePzJrkAnqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoGeUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmg
	gYR1jBl/Ln5nL3jJXLHs1jnGBsaXTF2MnBwSAiYSj76vZ4WwxSQu3FvP1sXIxSEksIhR4uy3
	e1DOX0aJ7fcnMIJUsQloSBx+/4wdxBYR8Jc4uW4JO0gRs8B0FokX00+xQHRsY5SYMnsbM0gV
	pwCPxLo/nUA2B4ewgK3E271+IGEWAVWJ/m3fwM7gBQrvedDHCmELSvyYfI8FxGYW0JJYv/M4
	E4QtL7F5zVuwMRIC6hKP/upC3GAl8X4LxCZmARGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaW
	VYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBieqZ1A7GlQ0WhxgFOBiVeHgTLuwMFGJNLCuu
	zD3EKMHBrCTCG/4XKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wCSaVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mltfqnjpx1N/22xV2YGra2V+7V9XO
	jGnpVcgJXGsZv/HFRZ1n/vJZ+5SM5J+apmeJxbR7fpDbIX8t0T1ppsv7dBOuCW4L9828dk+z
	/kXX3ptau6bmhzalnFji+my7QGfZm8j8e8+biv2cmVunzXjferz5YrfyufQzQtaLeWPt9y98
	b7HSNOyEEktxRqKhFnNRcSIA/nDGJ5gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Tomasz Figa wrote:
> 
> [...]
> 
> > > And I'm asking above all guys _really_ do review and maintaining the
> > > file or directories? I don't think so.
> >
> > I'm not really sure what makes you think they don't. I can see all of
> them
> > involved in works on mentioned drivers.
> >
> What's the role of maintainer? I mean, as you said, above guys are really
> do it...
> 
One more, I don't blame and I'm not saying it was wrong :)

- Kukjin

