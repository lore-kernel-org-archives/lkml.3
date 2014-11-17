Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKQAQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:16:23 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:46760 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaKQAQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:16:20 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "riel@redhat.com" <riel@redhat.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "davidlohr@hp.com" <davidlohr@hp.com>
Subject: Re: [PATCH 3/3] hugetlb: hugetlb_register_all_nodes(): add __init
 marker
Thread-Topic: [PATCH 3/3] hugetlb: hugetlb_register_all_nodes(): add __init
 marker
Thread-Index: AQHQAfspJhyZ+7Big0WOzYB81luw4Q==
Date: Mon, 17 Nov 2014 00:12:24 +0000
Message-ID: <20141117001301.GC4667@hori1.linux.bs1.fc.nec.co.jp>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
 <1415831593-9020-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1415831593-9020-4-git-send-email-lcapitulino@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.20]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <D9064B7E273C684ABEA1AD5EE820A2FC@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:33:13PM -0500, Luiz Capitulino wrote:
> This function is only called during initialization.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a10fd57..9785546 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2083,7 +2083,7 @@ static void hugetlb_register_node(struct node *node)
>   * devices of nodes that have memory.  All on-line nodes should have
>   * registered their associated device by this time.
>   */
> -static void hugetlb_register_all_nodes(void)
> +static void __init hugetlb_register_all_nodes(void)
>  {
>  	int nid;
>  
> -- 
> 1.9.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>