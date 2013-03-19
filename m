Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3CSAIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab3CSAIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:08:19 -0400
Date: Mon, 18 Mar 2013 20:07:32 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <1363651652-dcf5qvg4-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130318155125.GT10192@dhcp22.suse.cz>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130318155125.GT10192@dhcp22.suse.cz>
Subject: Re: [PATCH 9/9] remove /proc/sys/vm/hugepages_treat_as_movable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130318155125.GT10192@dhcp22.suse.cz>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 04:51:25PM +0100, Michal Hocko wrote:
> On Thu 21-02-13 14:41:48, Naoya Horiguchi wrote:
> > Now hugepages are definitely movable. So allocating hugepages from
> > ZONE_MOVABLE is natural and we have no reason to keep this parameter.
> 
> The sysctl is a part of user interface so you shouldn't remove it right
> away. What we can do is to make it noop and only WARN() that the
> interface will be removed later so that userspace can prepare for that.
> 

Yes, you're right. I'll replace the handler with noop.

Thanks,
Naoya
