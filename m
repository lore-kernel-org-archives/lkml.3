Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbaEOWiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:38:09 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:33651 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaEOWiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:38:07 -0400
Message-ID: <1400193482.5678.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm, hugetlb: move the error handle logic out of normal
 code path
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        mhocko@suse.cz, aarcange@redhat.com, steve.capper@linaro.org,
        kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 15:38:02 -0700
In-Reply-To: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
References: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 15:10 +0800, Jianyu Zhan wrote:
> alloc_huge_page() now mixes normal code path with error handle logic.
> This patches move out the error handle logic, to make normal code
> path more clean and redue code duplicate.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

