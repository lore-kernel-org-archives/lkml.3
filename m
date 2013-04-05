Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162659Ab3DEVNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:13:18 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:50297 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162478Ab3DEVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:13:17 -0400
Message-ID: <515F3E6C.8050009@gmail.com>
Date: Fri, 05 Apr 2013 17:13:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 04/10] migrate: clean up migrate_huge_page()
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-5-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-5-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/22/13 4:23 PM), Naoya Horiguchi wrote:
> Due to the previous patch, soft_offline_huge_page() switches to use
> migrate_pages(), and migrate_huge_page() is not used any more.
> So let's remove it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



