Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaDCPeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:34:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaDCPd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:33:56 -0400
Date: Thu, 3 Apr 2014 17:33:25 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        mgorman@suse.de, akpm@linux-foundation.org, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add support gigantic page allocation at
 runtime
Message-ID: <20140403153325.GM1500@redhat.com>
References: <1396462128-32626-1-git-send-email-lcapitulino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396462128-32626-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 02:08:44PM -0400, Luiz Capitulino wrote:
> Luiz Capitulino (4):
>   hugetlb: add hstate_is_gigantic()
>   hugetlb: update_and_free_page(): don't clear PG_reserved bit
>   hugetlb: move helpers up in the file
>   hugetlb: add support for gigantic page allocation at runtime

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
