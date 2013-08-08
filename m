Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3HHGcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:32:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52285 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab3HHGcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:32:20 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f5f6d00000105f-a4-52033b71f946
Content-transfer-encoding: 8BIT
Message-id: <1375943536.30982.1.camel@AMDC1943>
Subject: Re: [PATCH] [TRIVIAL] ARM: msm: fix compilation error in gpiomux
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 08:32:16 +0200
In-reply-to: <20130807210804.GB14845@codeaurora.org>
References: <1375857279-18082-1-git-send-email-k.kozlowski@samsung.com>
 <20130807174053.GA17551@codeaurora.org> <20130807210804.GB14845@codeaurora.org>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7pF1sxBBp2JFv+OTWGyeLz8H5vF
	1GVtrBabHl9jtZi4/yy7xeVdc9gsbl/mtfhxppvFgcOjpbmHzeNyXy+Tx+nJ+1k8Ni+p9/i8
	SS6ANYrLJiU1J7MstUjfLoErY+X0ncwFbewVm17/YWlgvM/axcjJISFgIrFy00EWCFtM4sK9
	9WxdjFwcQgJLGSX2HX7JDJLgFRCU+DH5HlARBwezgLzEkUvZIGFmAXWJSfMWMUPUf2aUODtr
	KSNEvb7E0WUf2UFsYQFPibeX3oLF2QSMJTYvX8IGYosANX/fcRJsGbNAM5PE3b65YAkWAVWJ
	A9vfgi3mBLru4oQHTBAbZjJKnPrSwwRxqpLE7vZO9gmMArOQHDgL4cBZSA5cwMi8ilE0tTS5
	oDgpPddIrzgxt7g0L10vOT93EyMk1L/uYFx6zOoQowAHoxIPb0cAU5AQa2JZcWXuIUYJDmYl
	Ed6LxUAh3pTEyqrUovz4otKc1OJDjEwcnFINjM0VbbNU5NrK31quCJeLXPBWZ+fMjPNK+nz/
	WNsfTz6ippjsw880d9mL43mvmna+jL787s3Sz/ffuIgcyJ8pJvVsUeLJFv4DeY9Z30922J+v
	/u9y2L66LzdTbZ4GmCl3K7HWMR/ucXP8qPj3X0ZAvkG/rNjLbX7MZXUGjJelj61VsY0RfC+8
	RImlOCPRUIu5qDgRAKVCjahTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2013-08-07 at 14:08 -0700, Stephen Boyd wrote:
> On 08/07, David Brown wrote:
> > On Wed, Aug 07, 2013 at 08:34:39AM +0200, Krzysztof Kozlowski wrote:
> > >Fix compilation error in gpiomux (CONFIG_MSM_GPIOMUX=y):
> > >arch/arm/mach-msm/gpiomux.c:24:13: error: static declaration of
> > >	???__msm_gpiomux_write??? follows non-static declaration
> > >arch/arm/mach-msm/gpiomux.h:85:6: note: previous declaration of
> > >	???__msm_gpiomux_write??? was here
> > >
> > >Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > 
> > Thanks, I'll pull this in.
> > 
> >  <https://patchwork.kernel.org/patch/2839921/>
> > 
> 
> I believe this is fixed by Rohit's patch that has already been
> taken in a pull request?
> 
> https://lkml.org/lkml/2013/7/26/608

Yes, Rohit's patch fixes the problem so this is already in linux-msm
tree.


Best regards,
Krzysztof


