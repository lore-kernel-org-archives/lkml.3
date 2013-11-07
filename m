Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3KGLdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:33:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45525 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3KGLde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:33:34 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-8d-527b7a8c2018
From: Tomasz Figa <t.figa@samsung.com>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2] of: irq: Check for reg property presence only when
 parsing interrupt-map
Date: Thu, 07 Nov 2013 12:33:26 +0100
Message-id: <1489788.4u43h9g5sZ@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <11085147.qYFvaZYATK@amdc1227>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <2177804.l4VGDTRFDu@amdc1227> <11085147.qYFvaZYATK@amdc1227>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xK7o9VdVBBreecFl8aGpltph/5Byr
	xYE/Oxgtvh5ewWhxedccNotT1z+zObB59LxpYfW4c20Pm8eVE02sHp83yQWwRHHZpKTmZJal
	FunbJXBl3Hh+i6lgH0vF4R37WBsYzzN3MXJySAiYSNzqv8kCYYtJXLi3nq2LkYtDSGApo8Si
	bXugnC4mia7ee2BVbAJqEp8bHrGB2CICyhJP2i6BTWIWuMMoseBwFogtLJAs8e7lZ0YQm0VA
	VeLQ2S6geg4OXgFNic8rskHC/ALqEu+2PWUCsUUF3CSm/zgINoZTQFti6fUGRoi9bYwST859
	BZvDKyAo8WMyxA3MAvIS+/ZPZYWwtSTW7zzONIFRcBaSsllIymYhKVvAyLyKUTS1NLmgOCk9
	11CvODG3uDQvXS85P3cTIyTUv+xgXHzM6hCjAAejEg/vjJqqICHWxLLiytxDjBIczEoivM0h
	1UFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGEMnFhauuemzIl425fyGxASjSRanzUWiV4aVvWSx
	Dquc5Pv1iOXsJpklStmOuWYnT1tv3OOxk+vdvsJ8gffJMb+2/JiksvqIYtpxwaDc4xze9frO
	kQpyKy0zP7OetO97IJLeqjdDnTtxmbS3itkSIY5lGUyXbvOftHd50c8/icVONsFgnflVJZbi
	jERDLeai4kQA+BpKZ1MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 05 of November 2013 16:21:36 Tomasz Figa wrote:
> This patch fixes the of_irq_parse_raw() function to check for reg
> property only when really parsing interrupt map property, as it is not
> required otherwise and breaks existing device trees.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/of/irq.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)

Please disregard this patch. It seems like Grant's fix that has been
already merged also fixes the same problem.

Best regards,
Tomasz

