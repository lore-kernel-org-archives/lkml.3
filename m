Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaCFVQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:16:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35105 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaCFVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:16:38 -0500
Message-ID: <5318E5AD.9090107@oracle.com>
Date: Thu, 06 Mar 2014 16:16:29 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] mm: add pte_present() check on existing hugetlb_entry
 callbacks
References: <53126861.7040107@oracle.com> <1393822946-26871-1-git-send-email-n-horiguchi@ah.jp.nec.com> <5314E0CD.6070308@oracle.com> <5314F661.30202@oracle.com> <1393968743-imrxpynb@n-horiguchi@ah.jp.nec.com> <531657DC.4050204@oracle.com> <1393976967-lnmm5xcs@n-horiguchi@ah.jp.nec.com> <5317FA3B.8060900@oracle.com> <1394122113-xsq3i6vw@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1394122113-xsq3i6vw@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 11:08 AM, Naoya Horiguchi wrote:
> And I found my patch was totally wrong because it should check
> !pte_present(), not pte_present().
> I'm testing fixed one (see below), and the problem seems not to reproduce
> in my environment at least for now.
> But I'm not 100% sure, so I need your double checking.

Nope, I still see the problem. Same NULL deref and trace as before.


Thanks,
Sasha
