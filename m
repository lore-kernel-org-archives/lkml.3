Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab3DGOFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:05:41 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53259 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab3DGOFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:05:40 -0400
Message-ID: <51617D37.1020502@gmail.com>
Date: Sun, 07 Apr 2013 10:05:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>, kosaki.motohiro@gmail.com
Subject: Re: [RFC][PATCH 0/9] extend hugepage migration
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com> <5148F830.3070601@gmail.com> <1363815326-urchkyxr-mutt-n-horiguchi@ah.jp.nec.com> <514A4B1C.6020201@gmail.com> <20130321125628.GB6051@dhcp22.suse.cz> <514B9BD8.9050207@gmail.com> <20130322081532.GC31457@dhcp22.suse.cz> <515E2592.7020607@gmail.com> <20130405080828.GA14882@dhcp22.suse.cz> <515E92CA.4000507@gmail.com> <20130405093034.GB31132@dhcp22.suse.cz> <5160BE9E.1050905@gmail.com>
In-Reply-To: <5160BE9E.1050905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Please refer to hugetlb_fault for more information.
> 
> Thanks for your pointing out. So my assume is correct, is it? Can pmd 
> which support 2MB map 32MB pages work well?

Simon, Please stop hijaking unrelated threads. This is not question and answer thread.

