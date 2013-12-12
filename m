Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3LLKrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:47:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8347 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3LLKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:47:44 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-e4-52a994267931
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Valentine Barshak'" <valentine.barshak@cogentembedded.com>,
        "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Kuninori Morimoto'" <kuninori.morimoto.gx@renesas.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131211183237.GI4699@google.com>
 <20131212070045.GO18380@S2101-09.ap.freescale.net>
In-reply-to: <20131212070045.GO18380@S2101-09.ap.freescale.net>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada,
 R-Car PCI host maintainers
Date: Thu, 12 Dec 2013 19:47:02 +0900
Message-id: <000001cef727$7da93730$78fba590$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac73B95+D+q0LgTVQsqSi56IVEJ94QAHrlAA
Content-language: ko
x-cr-hashedpuzzle: NMmu T99r oEbd ucm2 1kC0 +2dK AGoflw== AJcMfg== AJu0iw==
 AMspug== ASARwg== AVCWQg== Aa5G4g== AbG/Ow== Acck4g==
 AdhLcA==;18;YgBoAGUAbABnAGEAYQBzAEAAZwBvAG8AZwBsAGUALgBjAG8AbQA7AGgAbwByAG0AcwBAAHYAZQByAGcAZQAuAG4AZQB0AC4AYQB1ADsAagBhAHMAbwBuAEAAbABhAGsAZQBkAGEAZQBtAG8AbgAuAG4AZQB0ADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsAdQBuAGkAbgBvAHIAaQAuAG0AbwByAGkAbQBvAHQAbwAuAGcAeABAAHIAZQBuAGUAcwBhAHMALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHAAYwBpAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBzAGEAbQBzAHUAbgBnAC0AcwBvAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHMAaABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AdABlAGcAcgBhAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGEAZwBuAHUAcwAuAGQAYQBtAG0AQABnAG0AYQBpAGwALgBjAG8AbQA7AHIANgA1ADAAMwA3AEAAZgByAGUAZQBzAGMAYQBsA
	GUALgBjAG8AbQA7AHMAaABhAHcAbgAuAGcAdQBvAEAAbABpAG4AYQByAG8ALgBvAHIAZwA7AHQAaABpAGUAcgByAHkALgByAGUAZABpAG4AZwBAAGcAbQBhAGkAbAAuAGMAbwBtADsAdgBhAGwAZQBuAHQAaQBuAGUALgBiAGEAcgBzAGgAYQBrAEAAYwBvAGcAZQBuAHQAZQBtAGIAZQBkAGQAZQBkAC4AYwBvAG0AOwB3AGUAaQB5AGoALgBsAGsAQABnAG0AYQBpAGwALgBjAG8AbQA7AHkAbwBuAGcAagB1AG4AXwB3AGUAaQBAAHQAcgBlAG4AZABtAGkAYwByAG8ALgBjAG8AbQAuAGMAbgA=;Sosha1_v1;7;{50875A60-8A19-4619-B587-36DE4738979F};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 12 Dec 2013 10:46:34
 GMT;UgBlADoAIABbAFAAQQBUAEMASABdACAATQBBAEkATgBUAEEASQBOAEUAUgBTADoAIABBAGQAZAAgAEQAZQBzAGkAZwBuAFcAYQByAGUALAAgAGkALgBNAFgANgAsACAAQQByAG0AYQBkAGEALAAgAFIALQBDAGEAcgAgAFAAQwBJACAAaABvAHMAdAAgAG0AYQBpAG4AdABhAGkAbgBlAHIAcwA=
x-cr-puzzleid: {50875A60-8A19-4619-B587-36DE4738979F}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t8zY121KSuDDB6d0rdY0pRh8fKQpkXz
	1q+MFo1LLrNYXF54idXi1eFdjBabHl9jtbi8aw6bxdl5x9ksZpzfx2Qx588UZovOL7PYLB6s
	fstm8XiWsMXTdUuYLX7umsdisfzeSSaLD5eOMlvsXNfJ7iDs8WDqfyaPf4f7mTx2zrrL7rFg
	U6lHw4HzLB53ru1h89i8pN7j25mJLB59W1Yxeiy9d5TRY87PbywenzfJBfBEcdmkpOZklqUW
	6dslcGVcavrBWnCAvWLN/X7GBsYmti5GTg4JAROJ3x13mSBsMYkL99YDxbk4hASWMUr82/WX
	Babo+/NjTBCJ6YwSLQvPQ1X9YpQ4P3Ea2ChhAT+JpjmTmEFsNgE1iS9fDrOD2CICvhI3+i4w
	gjQwCzSwSlz6uRlsn5BAssSaFz/AmjkF7CXuf3nKBDEoVuJtwxuwOIuAqsTeZdvBbF4BW4nm
	Xx+gbEGJH5PvgZ3HLKAlsX7ncSYIW15i85q3QEdwAJ2tLvHory7EDUYSd378ZIcoEZHY9+Id
	2D0SAjd4JV6v+MEO8aapxNPdd9khEtM5JX69X84EcYSAxLfJh1gghspKbDrADFEvKXFwxQ2W
	CYzSs5CcNAvJSbOQnDQLye4FjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MULSV+8OxtsH
	rA8xJgOtn8gsJZqcD0x/eSXxhsZmRhamJqbGRuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAeEQ1g3V1O4fu8jv1n00SAvQuWaXJvohetNHc2bXVzIlbwtj9Uk9wxJnk
	E1fj9K+JvvvoNT+RNeBnZ1CZxO2LD21OTOnR4OVSP8ySz+RrqrC7hcO2qiTLd7dOwrNZqQrq
	Hp32KiVRL7NyhbnLJ7tN47zwJHW6mf+Bm//qGzVeSsw72f7F3EyJpTgj0VCLuag4EQBB5YzJ
	dQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsVy+t9jQV21KSuDDP5e1bRY0pRh8fKQpkXz
	1q+MFo1LLrNYXF54idXi1eFdjBabHl9jtbi8aw6bxdl5x9ksZpzfx2Qx588UZovOL7PYLB6s
	fstm8XiWsMXTdUuYLX7umsdisfzeSSaLD5eOMlvsXNfJ7iDs8WDqfyaPf4f7mTx2zrrL7rFg
	U6lHw4HzLB53ru1h89i8pN7j25mJLB59W1Yxeiy9d5TRY87PbywenzfJBfBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9qKRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuNT0g7XgAHvFmvv9jA2MTWxdjJwcEgImEt+f
	H2OCsMUkLtxbDxTn4hASmM4o0bLwPJTzi1Hi/MRpYB3CAn4STXMmMYPYbAJqEl++HGYHsUUE
	fCVu9F1gBGlgFmhglbj0czPYWCGBZIk1L36ANXMK2Evc//KUCWJQrMTbhjdgcRYBVYm9y7aD
	2bwCthLNvz5A2YISPybfYwGxmQW0JNbvPM4EYctLbF7zFugIDqCz1SUe/dWFuMFI4s6Pn+wQ
	JSIS+168A7tHQuAGr8TrFT/YId40lXi6+y77BEbRWUhWzEKyYhaSFbOQzFrAyLKKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIzg5PpPewbiqweIQowAHoxIP74uDK4KEWBPLiitzDzFKcDAr
	ifC6pK4MEuJNSaysSi3Kjy8qzUktPsSYDAyBicxSosn5wMSdVxJvaGxiZmRpZGZhZGJuTpqw
	kjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MLbOD9gb2cd90Mby57rnCxAWzo/0SYy4Zi8t0
	60/7XiDUPXfx4pWsxodCttukfvxukXGmSfHmS9ECgU8rpT7tnbtKzUmb23929PE3fS7b44SM
	jzJVzjbpV9ml3X7s+ZFeReunmUdPq3lM1zE7W1l0MmEzx+eCa5M8Dq5Ky9HJ0Vx612SbscBh
	JZbijERDLeai4kQA5f88z9IDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 12, 2013 4:01 PM, Shawn Guo wrote:
> On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> > +PCI DRIVER FOR IMX6
> > +M:	Shawn Guo <shawn.guo@linaro.org>
> 
> Thanks for the nomination.  But I think a better person for this
> position would be Richard Zhu <r65037@freescale.com> (copied).  He knows
> the driver and controller much better than myself, and most importantly
> he is the driver owner for Freescale kernel and he has the contact to
> Freescale PCIe hardware people.

I agree with Shawn Guo's opinion. :-)

Richard Zhu has been maintaining i.MX6 PCIe driver. Also he can contact
Freescale PCIe hardware engineers. Thus, he is the appropriate person
for the Maintainer of i.MX PCIe.

Best regards,
Jingoo Han

> 
> Shawn
> 
> > +L:	linux-pci@vger.kernel.org
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	Maintained
> > +F:	drivers/pci/host/*imx6*

