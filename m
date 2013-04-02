Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab3DBFef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:34:35 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34196 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297Ab3DBFee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:34:34 -0400
Message-ID: <515A6DE5.8000508@openvz.org>
Date: Tue, 02 Apr 2013 09:34:29 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] fix hugepage coredump
References: <1364836882-9713-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1364836882-9713-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi wrote:
> Hi,
>
> Here is 2nd version of hugepage coredump fix.
> See individual patches for more details.
>
> Thanks,
> Naoya Horiguchi

ACK to both patches


VM_* bits cleanup patchset was merged into v3.7, so only two recent stable kernels needs this fix.

