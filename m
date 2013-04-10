Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936939Ab3DJWmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:42:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51311 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab3DJWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:42:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130410215540.EE06231C107@corp2gmr1-1.hot.corp.google.com>
References: <20130410215540.EE06231C107@corp2gmr1-1.hot.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 10 Apr 2013 18:42:30 -0400
X-Google-Sender-Auth: 7B3UySTNgjIXJ3qumoZPv9u584g
Message-ID: <CAHGf_=oBdX4iZ1PES7Y2XnG-zBZMwO0FEuJt8fx3k0LCY2dYRQ@mail.gmail.com>
Subject: Re: + fix-hugetlb-memory-check-in-vma_dump_size.patch added to -mm tree
To: LKML <linux-kernel@vger.kernel.org>
Cc: mm-commits@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: <stable@vger.kernel.org>    [2.6.34+]

Not correct. It's 3.7 materials. See Michal or my comments.
cut-n-paste here.

>Just for the record. It should be stable for 3.7+ since (314e51b98)
>becuase then have lost VM_RESERVED check which used to stop hugetlb
>mappings.
> Acked-by: Michal Hocko <mhocko@suse.cz>
