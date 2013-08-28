Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3H1M6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:58:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59552 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H1M6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:58:47 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-46-521df405370c
From: Tomasz Figa <t.figa@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Leelakrishna A <l.krishna@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [Patch v2] pinctrl: Add s5pv210 support to pinctrl-exynos
Date: Wed, 28 Aug 2013 14:58:41 +0200
Message-id: <3439226.L4MiyJHvQr@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <CACRpkdYiB5OG-YPRozwEurPHECDzZjQUs2s_E8gCdeqDPyr+WA@mail.gmail.com>
References: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
 <CACRpkdYiB5OG-YPRozwEurPHECDzZjQUs2s_E8gCdeqDPyr+WA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xa7qsX2SDDC52a1vMP3KO1eJNbweL
	Re+Cq2wWO7fcYLOY8mc5k8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxOrznFbLH0+kUmiwnT17JY
	HF5xgMli3cvpQNabdlaLVwfbWCyOzVjC6CDosWbeGkaPBZ+vsHu8njyB0ePV6pmsHneu7WHz
	2Lyk3uPguz1MHn1bVjF6fN4k57FxbmgAVxSXTUpqTmZZapG+XQJXxv/uVywFX1krmk62sDYw
	XmHpYuTkkBAwkXg2/SsrhC0mceHeerYuRi4OIYGljBKffr5kgnC6mCQudnSzg1SxCahJfG54
	xAZiiwjoSHRv+8kKUsQs0M4m8XjWWbAiYQE3iZWNv5hBbBYBVYkZc5+ANfAKaEr8nXMBrIZf
	QF3i3banQBs4OEQFXCT6/maChDkFgiV+Ln0KdcUURom3K/pZIXoFJX5Mvgd2NrOAvMS+/VNZ
	IWwtifU7jzNNYBSchaRsFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIickv
	OxgXH7M6xCjAwajEw2uxWSZIiDWxrLgy9xCjBAezkggv/3bZICHelMTKqtSi/Pii0pzU4kOM
	TBycUg2M7FfNC2dtdiy4pRQsc1fVSnDKtcdrLh2bNbNYzivqXd5Fuz0vjzvM3VZc1ab7rPXW
	pLRHWkdWxLnMN3kaL+p8q3+Xz1619/OmF3j95EqY9MizKav6+gFDKafvwvFt830bL8UyShoI
	iCyfePLfvauvN0es4tr1XI41a8m147N9Y7YnKW04YxL5SomlOCPRUIu5qDgRAJwS16unAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 of August 2013 14:51:44 Linus Walleij wrote:
> On Tue, Aug 27, 2013 at 3:08 PM, Mateusz Krawczuk
> 
> <m.krawczuk@partner.samsung.com> wrote:
> > This patch implements pinctrl support and adds device tree bindings
> > for s5pv210.
> > 
> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> 
> Oh this one does add bindings, sorry for previous comment.
> 
> I want an ACK from Kukjin or Sylwester for this since it's
> something new for S5P.

Well, it does not touch anything outside drivers/pinctrl/, so my and your 
ACKs should be enough, but since this patch is just one day old, let's give 
it a bit more time for people to review it, if you don't have to hurry with 
it yet.

Best regards,
Tomasz

