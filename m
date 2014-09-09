Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaIIDrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:47:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10237 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaIIDrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:47:37 -0400
X-AuditID: cbfee690-f79ce6d00000115a-43-540e7857368f
From: kgene@kernel.org
To: "'Javier Martinez Canillas'" <javier@dowhile0.org>
Cc: linux-samsung-soc@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
 <CABxcv==ycrPw1MTv7X0baX2WfqgDS+4EEfGAWc+ZhpiR6=Uy+Q@mail.gmail.com>
In-reply-to: <CABxcv==ycrPw1MTv7X0baX2WfqgDS+4EEfGAWc+ZhpiR6=Uy+Q@mail.gmail.com>
Subject: RE: [PATCH v2 0/5] Add max77802 support for Peach boards
Date: Tue, 09 Sep 2014 12:47:35 +0900
Message-id: <04ab01cfcbe0$caeac4d0$60c04e70$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIxbNXd8qsEFbzMPRn3O1DlBdlXHAGANeQVmyjlPfA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zQ93wCr4Qg4MztSyaNxVbTH34hM3i
	7vPDjBZnlx1kszj6u8Di2u8ZbBabHl9jtbi8aw6bxYzz+5gsTl3/zGYxZdFhVgduj9kNF1k8
	/j6/DiRmtzJ7bFrVyeaxeUm9x5UTTawefVtWMXpsPl3t8XmTXABnFJdNSmpOZllqkb5dAlfG
	0Uld7AVP2Cr23O9hbmCcz9rFyMkhIWAicbB1GhOELSZx4d56ti5GLg4hgWWMEr/u74crOnlx
	PyOILSQwnVHi7zUNiKK/jBIndvUCdXNwsAF1T30iDVIjLKAlsXBLEwuILQLUe2PCQbChzAKn
	mCWmz+2H2jCNUaJp0io2kCpOgWCJ4+euskF0O0r8uzkDzGYRUJWYO3svM4jNK2Ah8WLuLkYI
	W1Dix+R7YBuYBdQlJs1bxAxhy0tsXvOWGeJqBYkdZ18zQlxhJbF6yi52iBoRiX0v3jFC1Czl
	kJjWqQexS0Di2+RDLCDPSAjISmw6ADVGUuLgihssExglZyHZPAvJ5llINs9CsmEBI8sqRtHU
	guSC4qT0IhO94sTc4tK8dL3k/NxNjJD0MGEH470D1ocYBTgYlXh4M4L5QoRYE8uKK3MPMZoC
	XTSRWUo0OR+YhPJK4g2NzYwsTE1MjY3MLc2UxHlfS/0MFhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cAo/nlp3qfA+oknTIW1ZX0XmEc6rvr/VtvSe8rtr+kqG0tPfgn9Ya3R97lcR3RK4MML
	hq+uCBiduvdGTbFl9hNZ02beTVGVT/q0I0oLY+6XHpniOGeJndhGwVu/k86YTHFe4Wt0V1mO
	NcdtB2vKZdu3r7v1Dtw2vrP/Sgxj0qfZH3NnRSzMOfVfiaU4I9FQi7moOBEAR/sHFgoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jQd3wCr4Qg58/VC2aNxVbTH34hM3i
	7vPDjBZnlx1kszj6u8Di2u8ZbBabHl9jtbi8aw6bxYzz+5gsTl3/zGYxZdFhVgduj9kNF1k8
	/j6/DiRmtzJ7bFrVyeaxeUm9x5UTTawefVtWMXpsPl3t8XmTXABnVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QrUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjKOTutgLnrBV7Lnfw9zAOJ+1i5GTQ0LAROLkxf2MELaY
	xIV769lAbCGB6YwSf69pdDFyAdl/GSVO7Opl6mLk4GADKpr6RBqkRlhAS2LhliYWEFsEaM6N
	CQfZQOqZBU4xS0yf288G0TyNUaJp0iqwqZwCwRLHz11lg+h2lPh3cwaYzSKgKjF39l5mEJtX
	wELixdxdjBC2oMSPyffANjALqEtMmreIGcKWl9i85i0zxNUKEjvOvmaEuMJKYvWUXewQNSIS
	+168Y5zAKDwLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC088z
	qR2MKxssDjEKcDAq8fBmBPOFCLEmlhVX5h5ilOBgVhLhZYgFCvGmJFZWpRblxxeV5qQWH2I0
	Bfp0IrOUaHI+MDXmlcQbGpuYGVkamVkYmZibK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpg
	ZLuhK5YWzKjtEyR8KnWTLhuvbSnDAikB+YlTe39lnjJj32LLZ3StZyl7zI1tX9g+Gd96+E43
	aJlMTGhqmOUtHuPJTJZrav4cKS3QuXi15nnFIk6zU6Z/boq9FON4tfkSR/4zqwfLLCXu/tx0
	XNpRa96uaf7q1pN2apy/s/Ro7b/Je/auLN65VYmlOCPRUIu5qDgRABlao2BVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
> Hello Kukjin,
> 
Hi,

> On Wed, Aug 20, 2014 at 1:19 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> >
> > This is a second version of the series that adds max77802 support for
> > the Peach Pit and Pi boards. The series also have all the pending
> > patches that were posted but depended on this support. I've picked
> > all the patches I found and rebased them to be sure that they apply
> > cleanly on top of linux-next. Also I've taken some DT snippets from
> > the downstream Chrome OS 3.8 kernel DTS for devices that use one of
> > these regulators as their input supply.
> >
> 
> Any comments on this series?
> 
Looks good to me but I just wanted to get ack from chrome guy, Doug? But since
Naveen tested, it should be fine I think. I'll take the series.

Thanks,
Kukjin

