Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3HMJq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:46:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26119 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3HMJq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:46:56 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-7f-520a00849517
Message-id: <1376387202.31048.2.camel@AMDC1943>
Subject: Re: [RFC 0/3] Pin page control subsystem
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, guz.fnst@cn.fujitsu.com,
        Benjamin LaHaise <bcrl@kvack.org>, Dave Hansen <dave.hansen@intel.com>,
        lliubbo@gmail.com, aquini@redhat.com, Rik van Riel <riel@redhat.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Date: Tue, 13 Aug 2013 11:46:42 +0200
In-reply-to: <1376377502-28207-1-git-send-email-minchan@kernel.org>
References: <1376377502-28207-1-git-send-email-minchan@kernel.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xK7otDFxBBr9v8ljMePiLxaLr3xYW
	i08vHzBaPG8/wGxxedccNot7a/6zWvyfsZzZYvK7Z4wWy76+Z7f4e2U9i8WhfavYLea1v2R1
	4PH4f3ASs8fOWXfZPRbvecnksWlVJ5vHpk+T2D0eHNrM4vF+31U2j74tqxg9Np+u9vi8SS6A
	K4rLJiU1J7MstUjfLoEr4/rFSSwFM1krOo6wNDDOY+li5OCQEDCROLxKtYuRE8gUk7hwbz1b
	FyMXh5DAUkaJA/t/sYEkhAQ+M0pcOOgAYvMK6EucW9PPBGILCxhK7D35iRXEZhMwlti8fAlY
	vYiAisSfp/8YQQYxC9xjkjg0YSJYA4uAqsTzI7vBijgFnCW+dPxmgljgJDFh2VF2EJtZQF1i
	0rxFzBAXKUnsbu+EistLbF7zlhniCEGJH5PvsUxgFJiFpGUWkrJZSMoWMDKvYhRNLU0uKE5K
	zzXSK07MLS7NS9dLzs/dxAiJoq87GJceszrEKMDBqMTDm/GRI0iINbGsuDL3EKMEB7OSCK/S
	H84gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYz1T0t90h3nMjyxLonfobv7cnX2u5+cOXd4We4u
	OfR0YkJqJ7u4y+VbDHq9SQuf+1uEsEbNYP7b0bHgyLsP7lHyD65wyKr/a/udIW31WyxzGrP3
	/imLFP3nqoTrO6pP+7/19O69Xms1nYSV7k7aErvTo3Humc+TivYFm378MOuqtgqHQOWilrNK
	LMUZiYZazEXFiQAqsw20gAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On wto, 2013-08-13 at 16:04 +0900, Minchan Kim wrote:
> patch 2 introduce pinpage control
> subsystem. So, subsystems want to control pinpage should implement own
> pinpage_xxx functions because each subsystem would have other character
> so what kinds of data structure for managing pinpage information depends
> on them. Otherwise, they can use general functions defined in pinpage
> subsystem. patch 3 hacks migration.c so that migration is
> aware of pinpage now and migrate them with pinpage subsystem.

I wonder why don't we use page->mapping and a_ops? Is there any
disadvantage of such mapping/a_ops?

Best regards,
Krzysztof

