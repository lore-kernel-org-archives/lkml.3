Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936927Ab3DJXcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:32:18 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39456 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556Ab3DJXcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:32:16 -0400
Date: Wed, 10 Apr 2013 16:32:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        stable@vger.kernel.org
Subject: Re: + fix-hugetlb-memory-check-in-vma_dump_size.patch added to -mm
 tree
In-Reply-To: <CAHGf_=oBdX4iZ1PES7Y2XnG-zBZMwO0FEuJt8fx3k0LCY2dYRQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1304101630560.23579@chino.kir.corp.google.com>
References: <20130410215540.EE06231C107@corp2gmr1-1.hot.corp.google.com> <CAHGf_=oBdX4iZ1PES7Y2XnG-zBZMwO0FEuJt8fx3k0LCY2dYRQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, KOSAKI Motohiro wrote:

> >Just for the record. It should be stable for 3.7+ since (314e51b98)
> >becuase then have lost VM_RESERVED check which used to stop hugetlb
> >mappings.

Ah, that's subtle, thanks for pointing it out.  Andrew, please annotate 
this only for 3.7+.
