Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3JWBDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:03:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35934 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3JWBDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:03:24 -0400
X-AuditID: cbfee691-b7f866d000001b8c-93-5267205aef7b
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Ray Jui'" <rjui@broadcom.com>, "'Chris Ball'" <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org
References: <1C995FCD38EDD646A035D3E5892E8C7C04C1674F@SJEXCHMB13.corp.ad.broadcom.com>
In-reply-to: <1C995FCD38EDD646A035D3E5892E8C7C04C1674F@SJEXCHMB13.corp.ad.broadcom.com>
Subject: RE: MMC request with REQ_DISCARD option may not release host when it
 should
Date: Wed, 23 Oct 2013 10:03:21 +0900
Message-id: <000a01cecf8b$ab6c0530$02440f90$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PbYu0mJta9GE3SVOQcBWDELh/QAAGeKBQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zQ90ohfQgg4lTVC22v97IZnF51xw2
	i6czN7M5MHvMun+WzePQlbWMHp83yQUwR3HZpKTmZJalFunbJXBlzJ/1kqlgBnfFvu36DYy/
	OboYOTkkBEwkJrf1sUPYYhIX7q1n62Lk4hASWMYo0bannQ2m6Mv7mawQiemMEpOfnWaBcP4w
	Snzu3A9WxSagJfH3zRvmLkYODhEBB4nXd+VBwswCChK/7m1iBbGFBCIkJr/+zQxicwpESkx+
	3scCYgsLhEncf3OZEcRmEVCV+NL3AizOK2ArcfLvLXYIW1Dix+R7LBAz9SQ+/rnNCGFrSzx5
	d4EVZK2EgLrEo7+6IGERASOJi6c3QZWLSOx78Y4R5GQJgX3sEt8aW5kgdglIfJt8iAWiV1Zi
	0wFmiH8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vO
	z93ECIm/iTsY7x+wPsSYDLR+IrOUaHI+MH7zSuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoHRfMvC2V8e6T445PnjmJ5WjsJETeXlEw7HXfB6yfZ8
	xYorgv1nLv3/GvhcZG7pRq5z0YVlr066CBa0vJtlsNg4cs5eXbZzi1kqdF74HCxxmb7a2d6b
	vTZhVWSmdlFChmLBLa3w3bc/K9UXPYlPbV3zoMat4RNb4anCpekGLlqr6u6sUbq24s08JZbi
	jERDLeai4kQA8JCjNdUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd0ohfQgg66DihbbX29ks7i8aw6b
	xdOZm9kcmD1m3T/L5nHoylpGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM+bPeslUMIO7Yt92/QbG3xxdjJwcEgImEl/ez2SFsMUkLtxbz9bFyMUhJDCdUWLy
	s9MsEM4fRonPnfvZQKrYBLQk/r55w9zFyMEhIuAg8fquPEiYWUBB4te9TWCDhAQiJCa//s0M
	YnMKREpMft7HAmILC4RJ3H9zmRHEZhFQlfjS9wIszitgK3Hy7y12CFtQ4sfkeywQM/UkPv65
	zQhha0s8eXeBFWSthIC6xKO/uiBhEQEjiYunN0GVi0jse/GOcQKj0Cwkk2YhmTQLyaRZSFoW
	MLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO7mfSOxhXNVgcYhTgYFTi4bVsTwsSYk0s
	K67MPcQowcGsJMLb7AsU4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5Hxg4skriTc0NjEzsjQy
	szAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkb9CMnjnc+Yjx8paTW62VndFfVk
	9eJgB4Osr1l5Yd0Lgiq4BWv6vNqtrx+vzW6fnZ1qvXr7v0gGrVpLvUbD8gU/Vn2Z7Xk38OOE
	E1+7TsWsu2hrOL2tI1eJbab01IwEi6/TIw4+ucHat6Gk59W6KPNP2ZUHOHK8bqxSfcul8Otk
	zxQef1b/fUosxRmJhlrMRcWJAFwVWd8yAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,

Thank you for information. Your analysis is right.
I also noticed same problem.
If you'd like to submit patch, not to report, please send it with regular form.
Or I could send similar patch I have.

Thanks,
Seungwon Jeon

On Wed, Oct 23, 2013, Ray Jui wrote:
Hi Seungwon/Chris,

We recently came across an eMMC issue that causes mmc_suspend to stuck waiting to claim the host. This issue only happens when one
of the MMC partitions is mounted with the discard option. By tracing the issue down in the kernel MMC stack, in the function
mmc_blk_issue_rq under drivers/mmc/card/block.c, we noticed the host will be released when req is valid and when req->cmd_flags is
set to one of the masks: MMC_REQ_SPECIAL_MASK. Based on the code comment, I believe the intention is to always release the host in
the case of special request (which include both REQ_DISCARD and REQ_FLUSH).

Note in function call mmc_blk_issue_discard_rq, the memory where req points to can be freed. This means at the bottom of the
mmc_blk_issue_rq, req->cmd_flags may contain garbage value and I believe this is what’s causing the issue that we are seeing in
mmc_suspend after the discard operation: In mmc_suspend, it blocks waiting to claim the host but the host was never released after
the discard operation.

Please help to review the attached patch that fixes the issue.

Thanks,

Ray Jui

