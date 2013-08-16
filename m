Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3HPLV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:21:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49290 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:21:53 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-3d-520e0b4f5247
Date: Fri, 16 Aug 2013 20:21:51 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Joerg Roedel'" <joro@8bytes.org>
Cc: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Varun Sethi'" <Varun.Sethi@freescale.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iommu/exynos: Follow kernel coding style for
 __sysmmu_enable return type
Message-id: <20130816202151.b47fae1e9ed249d06baa37d1@samsung.com>
In-reply-to: <20130814131547.GA5889@8bytes.org>
References: <1374766502-14823-1-git-send-email-a.motakis@virtualopensystems.com>
 <1374766502-14823-2-git-send-email-a.motakis@virtualopensystems.com>
 <003101ce89ed$52317330$f6945990$@samsung.com>
 <20130814131547.GA5889@8bytes.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfV1/br4gg48rNS3u3D3HarFgv7VF
	5+wN7BYfTx1nt9j0+BqrxeVdc9gsZpzfx2Rx8k8vo8XMW2tYHDg9nhycx+Tx73A/k8eda3vY
	PM5vWsPssXlJvcfkG8sZPT5vkvO4cvQMUwBHFJdNSmpOZllqkb5dAlfG0xlX2AtmslYs3bOK
	sYHxG3MXIyeHhICJxJ0/k1khbDGJC/fWs3UxcnEICSxjlFh/5jFc0fd7XawQiUWMErMfT2KG
	cCYxSbQdXQTWziKgKnF+zUI2EJtNQEti9dzjjCC2iICKRMu5H2ANzAJnmSSeLZoGViQskCxx
	72srWBGvgKPE3uvNLCA2p4C+xL/5m9ghNrxjlHixaT7UgRYSF5o62CEaBCV+TL4H1sAMtG3z
	tiZWCFteYvOat2DbJAQ+skvcXv4B6jwBiW+TDwE1cAAlZCU2HYD6TVLi4IobLBMYxWYhGTsL
	ydhZSMYuYGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESq707GG8fsD7EmAy0ciKzlGhy
	PjDW80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	2BUvU7XgoLSz5myuluzpXDcuVWe4r+87dtpMtOtsVNlOP+O1T5a8L7vYdVp7R8DhWI8qo418
	KhJfNI5pCDk+SXNYInqDvS4v4kG07i1FT7XW1fc/OS+9nFKwXKzX2fBqVtkUTQX2ODt7P6bw
	AC2tDT9PJCz5O/uFWOjOnPJ9D5l1pk3zVtZUYinOSDTUYi4qTgQAdXKfyusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV1/br4gg+8XVSzu3D3HarFgv7VF
	5+wN7BYfTx1nt9j0+BqrxeVdc9gsZpzfx2Rx8k8vo8XMW2tYHDg9nhycx+Tx73A/k8eda3vY
	PM5vWsPssXlJvcfkG8sZPT5vkvO4cvQMUwBHVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwjrGjKczrrAXzGStWLpnFWMD4zfmLkZODgkBE4nv97pYIWwxiQv31rN1MXJxCAks
	YpSY/XgSM4QziUmi7egisCoWAVWJ82sWsoHYbAJaEqvnHmcEsUUEVCRazv0Aa2AWOMsk8WzR
	NLAiYYFkiXtfW8GKeAUcJfZeb2YBsTkF9CX+zd/EDrHhHaPEi03zoe6wkLjQ1MEO0SAo8WPy
	PbAGZqBtm7c1sULY8hKb17xlnsAoMAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJEZwInkntYFzZYHGIUYCDUYmHl2Eib5AQa2JZcWXuIUYJDmYlEd4pD4FCvCmJlVWp
	RfnxRaU5qcWHGJOB4TGRWUo0OR+YpPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKa
	nZpakFoEs4WJg1OqgbHudZfE72s8ZkdXTnFdVsYiUTKtV6ZnCvuGExZ77E0b4+1Pcj1t3X3r
	teBsE3HPdWrnd+v9/mnY/uv84k27L9m5cjibfpwh+rBYj/XI/hLJbZVB9kJzPxyeterabN3N
	jJzmUx/+Xiw0yflPfcPXniD/x1UrZvn8z4kXlf/DcCvPfA1zX9N9S0slluKMREMt5qLiRABm
	nzawSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 15:15:49 +0200, 'Joerg Roedel' wrote:
> KyongHo,
> 
> On Fri, Jul 26, 2013 at 07:46:01PM +0900, Cho KyongHo wrote:
> > __sysmmu_enable() must return 1 if it is called with the same page table.
> > I have fixed it exynos_iommu_attach_device() to always return zero on success
> > in the next patchset which I will post today.
> > 
> > Thank you.
> 
> When you are fine with these patches please put them on-top of your
> patch-set when you re-submit. I will take them from there then.
> 

Ok.

Antonios,

Would you mind
if I submit your 2 patches on top of my patches with your signed-off?

KyongHo.

> 
> 	Joerg
> 
> 
