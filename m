Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab3HLAWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 20:22:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8834 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3HLAWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 20:22:44 -0400
X-AuditID: cbfee691-b7fef6d000002d62-31-52082ad29fa8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
In-reply-to: <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Date: Mon, 12 Aug 2013 09:22:42 +0900
Message-id: <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIbES82+ci1En5W4PdDWS8ji6IhHQLNAttXmOFY1qA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zA91LWhxBBjseqlgc3Kpp8frfdBaL
	iSsnM1tcXniJ1WL2/ccsFpd3zWFzYPOY0P+J0WPzCi2Pj09vsXh8WXWN2aNvyypGj8+b5ALY
	orhsUlJzMstSi/TtErgytuyby1jwkbni+YS5TA2MHcxdjJwcEgImEk3zH0DZYhIX7q1n62Lk
	4hASWMYocXT+RxaYonfXbrJAJKYzSjzetZcVwvnFKNF7YT5YFZuAmsSXL4fZQWwRAQ2JttVT
	wDqYBXYwSmzcsp4RJCEkUCGx78pvsAZOAU+Jcx8g4sICFhLt3a1gzSwCqhKz+6aB2bwClhJr
	r71ihbAFJX5MvgfUywE0VF1iypRckDCzgLzE5jVvoV5QkNhx9jUjxA1WEjMuNLJC1IhI7Hvx
	jhHkHgmBl+wSu3+8ZYLYJSDxbfIhsJkSArISmw5AzZGUOLjiBssERolZSDbPQtg8C8nmWUg2
	LGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRErsTdzDeP2B9iDEZaPtEZinR5Hxg7OeV
	xBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdF4kXW6
	bGFRoFDmWyVPudvHW1Y++eXMatN1NPbmbtZ1C58GXHwn+O/RYs2YrrZjYXPq9gX2PL3+LUpB
	54mY2JYp5k8N1cNSJv2/pVJqvTW9+frHG3VN+XIp+z2fsHbE2dt899Kzr2b/x/c4e3m8zs/9
	DzbOXsvTPf3FwZzS6UpWSiJMres59ymxFGckGmoxFxUnAgDW6rSF8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd1LWhxBBl+eKlgc3Kpp8frfdBaL
	iSsnM1tcXniJ1WL2/ccsFpd3zWFzYPOY0P+J0WPzCi2Pj09vsXh8WXWN2aNvyypGj8+b5ALY
	ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlBS
	KEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZmzZN5ex4CNzxfMJc5kaGDuY
	uxg5OSQETCTeXbvJAmGLSVy4t56ti5GLQ0hgOqPE4117WSGcX4wSvRfmg1WxCahJfPlymB3E
	FhHQkGhbPYUFpIhZYAejxMYt6xlBEkICFRL7rvwGa+AU8JQ49wEiLixgIdHe3QrWzCKgKjG7
	bxqYzStgKbH22itWCFtQ4sfke0C9HEBD1SWmTMkFCTMLyEtsXvMW6moFiR1nXzNC3GAlMeNC
	IytEjYjEvhfvGCcwCs1CMmkWwqRZSCbNQtKxgJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZwYngmvYNxVYPFIUYBDkYlHl6PL+xBQqyJZcWVuYcYJTiYlUR4FylwBAnxpiRWVqUW5ccX
	leakFh9iTAb6cyKzlGhyPjBp5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUg
	tQhmCxMHp1QDo64f6/+bttWJogd7O4pZe1XWZ2Qb+ynyPBN1/fUvlHdjgtLx1O2LgptOxGgr
	P1smvaf1rM7CGYc3260sWVawU73goaDKWp/V72Y/7F3Juy1JbFOD+N1H3/aJMbS6VefOuc51
	37X7Z7/jiexlrDc/9t50WW2vu3/6f+b0sL3fDcsNq/7/Kt+8UImlOCPRUIu5qDgRAEbWNQdQ	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 10, 2013 7:05 AM, Anton Vorontsov wrote:
> On Tue, Jul 30, 2013 at 05:19:27PM +0900, Jingoo Han wrote:
> > Use the wrapper function for retrieving the platform data instead of
> > accessing dev->platform_data directly.
> 
> Um.. what is the benefit or rationale of this patch?

CC'ed Joe Perches, Dan Carpenter

Hi Anton Vorontsov,

Usually, using the wrapper function makes the code simpler.
Also, it make the code more readable.


Best regards,
Jingoo Han

