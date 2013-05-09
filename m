Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3EIX3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:29:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19539 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3EIX3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 19:29:42 -0400
X-AuditID: cbfee691-b7fe56d000004b96-74-518c31651ae7
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1368034349-15091-1-git-send-email-dianders@chromium.org>
 <CAD=FV=X2n+zHZ3frorwW7L1yybnWWK1=-rWMQJQFus3eNiFFeQ@mail.gmail.com>
 <CAOesGMi=K4iJKjSk3RoynhiCMPPT98v5jADnqZ__TwX_YLw65Q@mail.gmail.com>
 <1614776.P66h1VoFPp@amdc1227>
 <CAD=FV=X1XL++O43GBcJK5Js=ci8pfoj=uSADMcqq_jGJEvhXdQ@mail.gmail.com>
In-reply-to: <CAD=FV=X1XL++O43GBcJK5Js=ci8pfoj=uSADMcqq_jGJEvhXdQ@mail.gmail.com>
Subject: RE: [PATCH] ARM: exynos: Select PINCTRL_EXYNOS for exynos5
Date: Fri, 10 May 2013 08:29:40 +0900
Message-id: <044901ce4d0d$142a8e90$3c7fabb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5M4Jgwgc8nihp0S3KrEM/h5NT9GwAK2dPA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zQ91Uw55AgwN72SwezNvGZnF22UE2
	i02Pr7FaXN41h81ixvl9TBa3L/NanLr+mc3i25ZtjBbrZ7xmsTg2YwmjA5dHS3MPm8fshoss
	Hneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MpYfHcnY8FOnopNTecZ
	GxjvcnYxcnJICJhILP4xnQ3CFpO4cG89kM3FISSwjFFi/r+3LDBFK0//YIFITGeUmHLtJhOE
	85dR4uv2RewgVWwCGhKH3z8Ds0UE/CVezHsIVsQssI1JYt7TH+wQHbuYJBZfPga2kFMgWGJa
	7xYwW1jAWaL3+WJmEJtFQFXiVfdbRhCbV8BWYvv2BawQtqDEj8n3wG5iFtCSWL/zOBOELS+x
	ec1boF4OoFvVJR791YU4wkiiedplZogSEYl9L94xgtwgIdDLIdF/aCMrxC4BiW+TD7FA9MpK
	bDrADPGypMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ
	+bmbGCERP3EH4/0D1ocYk4HWT2SWEk3OByaMvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwGrS6rVc713IhNi1JaNuTF14zX2y78HldNptAZM0c
	n83nLKbPb86Jsk2JnjbRxHbxjLM+55jjbdmmZc+Ln3njpJoay8TE/X2C2lOn6P2Ym5X2bsnz
	Q8JGBc/uVkrNkXBze3J5682bQWs+JvF/37Ra+UNH3L0f2bomCjbJ22Y9uXSsUO1LS1PBCSWW
	4oxEQy3mouJEADySo8cOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd1Uw55Ag0fRFg/mbWOzOLvsIJvF
	psfXWC0u75rDZjHj/D4mi9uXeS1OXf/MZvFtyzZGi/UzXrNYHJuxhNGBy6OluYfNY3bDRRaP
	O9f2sHlsXlLvceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsY8xYfHcnY8FOnopNTecZGxjvcnYxcnJICJhIrDz9gwXCFpO4cG89WxcjF4eQwHRG
	iSnXbjJBOH8ZJb5uX8QOUsUmoCFx+P0zMFtEwF/ixbyHYEXMAtuYJOY9/cEO0bGLSWLx5WNs
	IFWcAsES03q3gNnCAs4Svc8XM4PYLAKqEq+63zKC2LwCthLbty9ghbAFJX5Mvgd2E7OAlsT6
	nceZIGx5ic1r3gL1cgDdqi7x6K8uxBFGEs3TLjNDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUha
	FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITibPpHcwrmqwOMQowMGoxMP7YWd3oBBr
	YllxZe4hRgkOZiUR3g0bgEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0x0eSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKHfyldvsObuWGwqmxtVIbrwt
	535WKqhxkUtDmj9TVe3zaRYR3045ZnDrzApY8U3r+dPgP9HHeO6rbNCV3/FIZapb+v+1rFLp
	rVOvXE6/mSP9zWTF87hn6lmcdznMhHm+X/Z8tfdey7wP73l+xKro+oSLR+5huFW5a/+T9a+m
	rH3724AlqydcXYmlOCPRUIu5qDgRAIJGK6pqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> Tomasz / Olof,
> 
Hi Doug, Tomasz and Olof

> On Thu, May 9, 2013 at 2:45 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> >> Nothing stops you from doing that on your own. I tend to push back
> >> onto the maintainers to get them engaged in their own housekeeping,
> >> but anyone is free to :)
> 
> I will probably leave this to the maintainers at this point...  ;)
> 


> >> Yeah, it should -- this is just in transition since 5440 was first out
> >> of the gate with pinctrl.
> >
> > AFAIK, Exynos5440 contains a completely different pin controller block,
> which
> > is not compatible with pinctrl-samsung driver, so I don't see any point
> of
> > moving it under PINCTRL_EXYNOS, which is currently used for Exynos 4210,
> 4x12
> > and 5250, but will be also extended with driver data for S5PV210 as
well.
> >
> > I'd say that CPU_EXYNOS4210, SOC_EXYNOS4212, SOC_EXYNOS4412 and
> SOC_EXYNOS5250
> > should select PINCTRL_EXYNOS and SOC_EXYNOS5440 should be left as is,
> > selecting PINCTRL_EXYNOS5440.
> 
> OK, sounds reasonable.  I didn't dig into all of the details of the
> 5440 pin control driver and don't have a user manual in front of me.
> I will do as you say.
> 
Tomasz is right. The current exynos pinctrl stuff is quite different with
exynos5440 pinctrl, it means there is no reason to move exynos5440 pinctrl
under exynos pinctrl. Of course, both can be built together without problem.

> New patch coming shortly.
> 
Thanks, the PINCTRL_EXYNOS can be moved into under SoC condition not board.

- Kukjin

