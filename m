Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3HIA6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:58:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18375 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab3HIA6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:58:11 -0400
X-AuditID: cbfee691-b7fef6d000002d62-8b-52043ea14b07
Message-id: <52043EA3.3080704@samsung.com>
Date: Fri, 09 Aug 2013 09:58:11 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, liuj97@gmail.com,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] Revert
 "mm/memory-hotplug: fix lowmem count overflow when offline pages"
References: <1375260602-2462-1-git-send-email-jy0922.shim@samsung.com>
 <1572085.gN7iX7IvMe@amdc1032> <3049413.HnxJdeugZK@amdc1032>
In-reply-to: <3049413.HnxJdeugZK@amdc1032>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkRHehHUuQwa5NXBZz1q9hs9g4Yz2r
	xbMt3BaXd81hs7i35j+rRfORjUwObB47Z91l99j0aRK7x4kZv1k8+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK+P/pUNsBYc4Kt41PGJpYJzC3sXIySEhYCLx408DlC0mceHeerYuRi4OIYGl
	jBKzP89ihCk69n05C0RiEaPEu7cdjBDOK0aJf7cPs4FU8QpoSdz/9YkVxGYRUJWY9nEBC4jN
	JqAncWfbcSYQW1QgTGLJt8dQ9YISPybfA6sREbCQWLviLZjNLFAnceXbXLDNwgLxEndfn2CC
	WNbCKLFk2TywIk6gZfuO9jBBNFhLrJy0jRHClpfYvOYtM0iDhMAhdon/3TOYIS4SkPg2+RBQ
	MwdQQlZi0wFmiNckJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPWKE3OLS/PS
	9ZLzczcxAuPt9L9nE3cw3j9gfYgxGWjlRGYp0eR8YLzmlcQbGpsZWZiamBobmVuakSasJM6r
	3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRM/lq1fcFSyW0lG/IS/W3Ts0Pc37ztS/v
	XOuJ/Fef7vUd0Ehac6bxE/tRmVllmal6t7VE9v2KODa3JPeho2bbgvU/XZ7u+/hAaGrPjPAT
	Jz9f87JV+OX2TklomdTeFL35bPZZ+2fvEvnr1HzT/rHC1vbt15wP3OoX/j5pduLjtVNl7oZ9
	Zps8S4mlOCPRUIu5qDgRAB/BXLzNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd2FdixBBsvXM1vMWb+GzWLjjPWs
	Fs+2cFtc3jWHzeLemv+sFs1HNjI5sHnsnHWX3WPTp0nsHidm/Gbx6NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ/y8dYis4xFHxruERSwPjFPYuRk4O
	CQETiWPfl7NA2GISF+6tZ+ti5OIQEljEKPHubQcjhPOKUeLf7cNsIFW8AloS9399YgWxWQRU
	JaZ9XADWzSagJ3Fn23EmEFtUIExiybfHUPWCEj8m3wOrERGwkFi74i2YzSxQJ3Hl21xGEFtY
	IF7i7usTTBDLWhglliybB1bECbRs39EeJogGa4mVk7YxQtjyEpvXvGWewCgwC8mOWUjKZiEp
	W8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOJqfSe9gXNVgcYhRgINRiYdXcTtzkBBr
	YllxZe4hRgkOZiUR3hdZQCHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqcD0w0eSXxhsYmZkaW
	RuaGFkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqH/j+1fBjkIOTu/8DYfv5xzY
	9XzJyptXuB5sW39m74Tz2+MDL/n53Npfev38pqtX7inJNke+1pepOrdv3YJn4vaqqtHzerJF
	zZwYs8y33Ld0TJWafmF1YoBewaGMjyqKDeUvvG5nFgTKL3tu1zPJU5trw7w6N9FaFTnbz9ez
	Uld+qEkwcLs3Q4mlOCPRUIu5qDgRAHQCXSgqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 08:48 PM, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday, July 31, 2013 01:17:46 PM Bartlomiej Zolnierkiewicz wrote:
>> Hi,
>>
>> On Wednesday, July 31, 2013 05:50:02 PM Joonyoung Shim wrote:
>>> This reverts commit cea27eb2a202959783f81254c48c250ddd80e129.
>> Could you please also include commit descriptions, i.e.
>> commit cea27eb2a202959783f81254c48c250ddd80e129 ("mm/memory-hotplug: fix
>> lowmem count overflow when offline pages")?
>>
>>> Fixed to adjust totalhigh_pages when hot-removing memory by commit
>>> 3dcc0571cd64816309765b7c7e4691a4cadf2ee7, so that commit occurs
>>> duplicated decreasing of totalhigh_pages.
>> Could you please describe it a bit more (because it is non-obvious) how
>> the commit cea27eb effectively does the same totalhigh_pages adjustment
>> that is present in the commit 3dcc057?
> Err, the other way around. How the commit 3dcc057 ("mm: correctly update
> zone->managed_pages") does what cea27eb ("mm/memory-hotplug: fix lowmem
> count overflow when offline pages") did.
>

OK, i updated to patch v2.

Thanks.
