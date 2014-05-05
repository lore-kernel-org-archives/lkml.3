Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaEEI4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:56:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52404 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaEEI4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:56:44 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fae6d000004d6d-e7-5367524a935a
Content-transfer-encoding: 8BIT
Message-id: <1399280201.17696.6.camel@AMDC1943>
Subject: Re: Idea: regulator: Merge s2mpa01 with s2mps11
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sachin Kamat <sachin.kamat@samsung.com>, Mark Brown <broonie@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 May 2014 10:56:41 +0200
In-reply-to: <CAK9yfHwge_4HFzqj+4kgcY+fQTy1uQBp-=RhyX2YYRt3hKLPXA@mail.gmail.com>
References: <1398864419.14545.8.camel@AMDC1943>
 <CAK9yfHwge_4HFzqj+4kgcY+fQTy1uQBp-=RhyX2YYRt3hKLPXA@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xa7peQenBBsd6hSw2Xb/OanF51xw2
	i5N/ehktrlw6xWZxccUXJgdWjzvX9rB59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8ad+0fZ
	C+ZwVJzrOcHSwLiWrYuRk0NCwETiwJyvjBC2mMSFe+vB4kICSxklHj8pArF5BQQlfky+x9LF
	yMHBLCAvceRSNkiYWUBdYtK8RcxdjFxA5Z8ZJWZPamCBqNeXeHppJ9gcYQELiSVLfoDNZxMw
	lti8fAlYXERAS+Jl93ImkGZmgemMEu/232cGSbAIqEo0t3wHK+IUCJZYue4mE8RBZRIdK1+x
	QxyqLDFv/zGmCYwCs5DcNwvhvllI7lvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyR0
	v+5gXHrM6hCjAAejEg+vh3dKsBBrYllxZe4hRgkOZiUR3lmM6cFCvCmJlVWpRfnxRaU5qcWH
	GJk4OKUaGLcd0fA+2G14zbRvQstvhZDJj495KE92VpxmNWtHK8PkCS9n/T9m8rfzN4tj7vKX
	B2fI3Xhz4CH70++cCYkF4seWq/ZsZHv14OlE07+RMSkPLQtfzWl6dVMvbU1Zfch/05nzhBsm
	m/hKnGs551HNOWGR/HvdJ/vXmKdFmla5rGFS2iRsf3L7p24lluKMREMt5qLiRABVi9ixOwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-30 at 20:57 +0530, Sachin Kamat wrote:
> Hi Krzysztof,
> 
> On 30 April 2014 18:56, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Dear Sachin,
> >
> >
> > The S2MPA01 and S2MPS1X PMICs regulator drivers look quite similar to
> > each other. Most of the S2MPA01 driver is the same as S2MPS11 (except
> > changes added for supporting S2MPS14).
> >
> > I would like to merge these drivers into one. However I do not have
> > neither any board with S2MPA01 nor S2MPA01 datasheet.
> >
> > What do you think about merging them?
> 
> It is a good idea to merge them. That was my initial plan too.
> I appreciate your offer to do the same.
> 
> >Could you test it later when I will finish the development?
> 
> I will not be able to do it immediately though as currently I am involved
> with some other activity on a different h/w and will be on vacation for some
> time later next week onwards.

It is not an urgent task. I'll let you know when I got some working
solution.

Best regards,
Krzysztof

