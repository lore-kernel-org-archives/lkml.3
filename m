Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982Ab3FSBaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:30:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30786 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:30:22 -0400
X-Spam-Score: -100.8
Message-ID: <51C1097B.4060600@asianux.com>
Date: Wed, 19 Jun 2013 09:29:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu, lczerner@redhat.com, liuj97@gmail.com,
        cody@linux.vnet.ibm.com, Mel Gorman <mgorman@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: next-20130607 BUG: Bad page state in process systemd pfn:127643
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Valdis:

Could you delete the patch: (8094dd4 mm/page_alloc.c: add additional
checking and return value for the 'table->data') and try it again to
see whether still has this issue ?

If no issue any more, it means I cause this issue directly, and I
should continue to analyze it to find the root cause.

Else (still has this issue), please continue to delete another related
patches step by step to catch the direct cause (to speed up, each time,
can delete half of related patches to see the result).

When catch the direct cause, as one of related members, I need continue
to find the root cause with you together.

Thanks.


Also sorry for replying late. You already sent the mail to me. but I
don't know why I did not receive it. and yesterday I checked my the
other mail which also can receive mailing list, then find this mail.

So if sent/cc mail to me and get no response, please help to re-send again.


Thanks.
-- 
Chen Gang

Asianux Corporation
