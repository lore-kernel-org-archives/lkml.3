Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966755Ab3HIGHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:07:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15215 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3HIGHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:07:48 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-44-520487327745
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Nick Piggin'" <npiggin@kernel.dk>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 3/3] block: brd: Staticize 'rd_size'
Date: Fri, 09 Aug 2013 15:07:46 +0900
Message-id: <000301ce94c6$c4d9da10$4e8d8e30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UxrlqPA4kuGqjSnmvN8sFwVA1sA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zQ12jdpYgg6v/rCzmrF/DZnF54SVW
	i8u75rBZXPvfy+7A4nH5bKnHiRm/WTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro/HtHPaC
	uZwV99bcZG9gPMrexcjJISFgIjF13xdmCFtM4sK99WwgtpDAMkaJp/usYGoufFzCAhFfxCgx
	v8+wi5ELyP7FKLF52k2wBJuAmsSXL4eBhnJwiAjoS7S1aICEmQXSJS7ubQObLyxgIfHr3nwm
	EJtFQFViU1832C5eAUuJM88msELYghI/Jt9jgejVkli/8zgThC0vsXnNW6g7FSR2nH3NCGKL
	COhJbOp8wQ5RIyKx78U7RpDbJAQ2sUvc7+tmhVgmIPFt8iEWkNskBGQlNh2AmiMpcXDFDZYJ
	jGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSIRN2MF474D1
	IcZkoPUTmaVEk/OBEZpXEm9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBkY1s5roVq9jopU3bN/9K1JyEGbljWzYdGte5OU7O69dONfInR1672B50MVV
	fzya6uy1Q7i1X34z3b9r/t5zpu3KD44nMAYZn1Zw+cnK/TTZ7HHV/2vuBtNeb2LPPjMxdm12
	YCWnyHuXj0vmPnzYfVosJ8fW6qLFP/NVFiZzV4kau3Kla6+awqjEUpyRaKjFXFScCABDUpvC
	xgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV2jdpYgg6cvzCzmrF/DZnF54SVW
	i8u75rBZXPvfy+7A4nH5bKnHiRm/WTz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaPx7Rz2grmcFffW3GRvYDzK3sXIySEhYCJx4eMSFghbTOLCvfVs
	ILaQwCJGifl9hl2MXED2L0aJzdNughWxCahJfPlyGKiZg0NEQF+irUUDJMwskC5xcW8bM4gt
	LGAh8evefCYQm0VAVWJTXzfYTF4BS4kzzyawQtiCEj8m32OB6NWSWL/zOBOELS+xec1bZoh7
	FCR2nH3NCGKLCOhJbOp8wQ5RIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4gp9J7WBc2WBxiFGAg1GJh1dxO3OQEGtiWXFl7iFGCQ5mJRHe
	F1lAId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJpe8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tFoHCgmkJ5akZqemFqQWwWxh4uCUamA8WKtT+rU1yWE974IyRk1rHg0pN6arksuda7tYVT+1
	2/QpPytWL/uXVzU1TLvuk6dNR/ylBeuvGHHJuuVvnnpWz8pVvLFxae7ZnyJftAvWvlvbwLVs
	7qcFNy61ucmIHmV44STTorNpyi7WzXx3vSVEwudO1HrgeneWyJE4A4HqkgWfJrkqhCuxFGck
	GmoxFxUnAgD8vDHJJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 09, 2013 1:07 PM, Jingoo Han wrote:
> 
> 'rd_size' is used only in this file.
> Fix the following sparse warning:
> 
> drivers/block/brd.c:432:5: warning: symbol 'rd_size' was not declared. Should it be static?
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/block/brd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Sorry, please ignore this patch.
It makes link error as below:

arch/arm/kernel/built-in.o: In function `parse_tag_ramdisk':
/home/jin9/mainline/linux-next_130806_sparse/arch/arm/kernel/atags_parse.c:103: undefined reference to `rd_size'

Best regards,
Jingoo Han

> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 9bf4371..650530ab 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -429,7 +429,7 @@ static const struct block_device_operations brd_fops = {
>   * And now the modules code and kernel interface.
>   */
>  static int rd_nr;
> -int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> +static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
>  static int max_part;
>  static int part_shift;
>  module_param(rd_nr, int, S_IRUGO);
> --
> 1.7.10.4


