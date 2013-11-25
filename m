Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3KYX0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:26:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51046 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3KYX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:26:45 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-44-5293dcb31230
From: Kukjin Kim <kgene@kernel.org>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Marc Zyngier'" <marc.zyngier@arm.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1382533861-12688-1-git-send-email-dianders@chromium.org>
 <CAD=FV=VHLHL-VxUr_G7CoBQ5UY8t1jbdTCwcGz9BYrR5C3cpAQ@mail.gmail.com>
 <CAOesGMhfioBLMgmFi7EHrkVys_96KKzBcLp0C8sdLaRs5FMJBw@mail.gmail.com>
In-reply-to: <CAOesGMhfioBLMgmFi7EHrkVys_96KKzBcLp0C8sdLaRs5FMJBw@mail.gmail.com>
Subject: RE: [PATCH] ARM: dts: Add max77686 RTC interrupt to cros5250-common
Date: Tue, 26 Nov 2013 08:26:43 +0900
Message-id: <1ad301ceea35$cd1eb0f0$675c12d0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7qNF0DufjGWbhjTGCV90sTUHrotQAAVcTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zI93NdyYHGRxYp2NxdtlBNotNj6+x
	WlzeNYfN4vZlXou/d/6xWZy6/pnNYsqiw6wW62e8ZnHg8Fgzbw2jR0tzD5vH7IaLLB6bl9R7
	XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGRM+r2EqmMJesb77KUsD4zHWLkZODgkB
	E4nnq9qhbDGJC/fWs3UxcnEICSxjlPje183UxcgBVtSzwgkiPp1RYtPB21BFfxklZkzpYQcp
	YhNQlmhs0gcZJCygJbFwSxMLiC0i4CexoXMDmM0s8JpRoq1fFKL3MqPEuQULmUASnALBEsv7
	J7FDNPtIbJ9xF8xmEVCVmPrqGZjNK2Ao8fPkSjYIW1Dix+R7UEO1JNbvPM4EYctLbF7zlhni
	aHWJR391IW4wkpj4YzYrRImIxL4X7xhBbpAQaOWQuNNwhhVil4DEt8mHWCB6ZSU2HWCGBIqk
	xMEVN1gmMErOQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIfHe
	u4Px9gHrQ4zJQOsnMkuJJucD00VeSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTBOi/ObuVv8cY9IyOcrP3Ojw93vmbtMDLrGyKguey1EPzzaWOEC
	R/5hcZ+9/J39i841Gk9VX/00dO27RobYzFPXb9h5psXaxaobXOw31b8290XjX56g6nyLCZGR
	DX9SFS716prEX5cWkHL59WTy98NMfA+sDspeK/x54MLWGP5rJ7bnVqVeVVFiKc5INNRiLipO
	BADyPUoiDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd3NdyYHGcx9rm5xdtlBNotNj6+x
	WlzeNYfN4vZlXou/d/6xWZy6/pnNYsqiw6wW62e8ZnHg8Fgzbw2jR0tzD5vH7IaLLB6bl9R7
	XDnRxOrRt2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDMm
	fF7DVDCFvWJ991OWBsZjrF2MHBwSAiYSPSucuhg5gUwxiQv31rN1MXJxCAlMZ5TYdPA2lPOX
	UWLGlB52kAY2AWWJxiZ9kAZhAS2JhVuaWEBsEQE/iQ2dG8BsZoHXjBJt/aIQvZcZJc4tWMgE
	kuAUCJZY3j+JHaLZR2L7jLtgNouAqsTUV8/AbF4BQ4mfJ1eyQdiCEj8m34MaqiWxfudxJghb
	XmLzmrfMEA+oSzz6qwtxg5HExB+zWSFKRCT2vXjHOIFReBaSSbOQTJqFZNIsJC0LGFlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgQnk2fSOxhXNVgcYhTgYFTi4ZXonBwkxJpYVlyZe4hR
	goNZSYS3dxJQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBiS6vJN7Q2MTMyNLIzMLIxNyc
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjnxszQVJpq7Rgxa064bbvX/LOJQtm/9ScG
	zzm4x0dXN0vc/zhv56Lg7YpH4p4s2Ztd0BF1Knefv+5r28bQ+zHrTm8rU5ip/O8L76IjKhfv
	THgUvYTnrVggt+XKk5a2/9fXW5YKdzTyyvDJxV3k6hLTTeLY4vcp0vCG5ISoNZ3Jhw3u2ChO
	0lBiKc5INNRiLipOBABUTbsVagMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Mon, Nov 25, 2013 at 3:11 PM, Doug Anderson <dianders@chromium.org>
> wrote:
> > Olof or Kukjin,
> >
> > On Wed, Oct 23, 2013 at 6:11 AM, Doug Anderson <dianders@chromium.org>
> wrote:
> >> Without the interrupt you'll get problems if you enable
> >> CONFIG_RTC_DRV_MAX77686.  Setup the interrupt properly in the device
> >> tree.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >>  arch/arm/boot/dts/cros5250-common.dtsi | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >
> > Would one of you be interested in applying this to your tree, with
> > Marc's "Tested-by"?  I know there are lots more things to fixup in the
> > dts, but this is one that I know works.  ;)
> 
> Yes, I'll apply this to fixes for 3.13, and mark it for stable 3.12 at
> least.
> 
Olof, thanks.

Please add my ack on this if you want.

- Kukjin

