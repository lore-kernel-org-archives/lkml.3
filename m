Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3DBSJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:09:05 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:59365 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845Ab3DBSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:09:03 -0400
Date: Tue, 2 Apr 2013 11:09:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Simon Jeons <simon.jeons@gmail.com>
cc: Zhouping Liu <zliu@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Amos Kong <akong@redhat.com>
Subject: Re: THP: AnonHugePages in /proc/[pid]/smaps is correct or not?
In-Reply-To: <515ACDC9.2090506@gmail.com>
Message-ID: <alpine.DEB.2.02.1304021106190.17138@chino.kir.corp.google.com>
References: <383590596.664138.1364803227470.JavaMail.root@redhat.com> <alpine.DEB.2.02.1304011512490.17714@chino.kir.corp.google.com> <515ACDC9.2090506@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Simon Jeons wrote:

> Both thp and hugetlb pages should be 2MB aligned, correct?
> 

To answer this question and your followup reply at the same time: they 
come from one level higher in the page table so they will naturally need 
to be 2MB aligned.
