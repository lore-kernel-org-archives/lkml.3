Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaFFLDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaFFLDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:03:08 -0400
Date: Fri, 6 Jun 2014 13:03:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
Message-ID: <20140606110306.GD26253@dhcp22.suse.cz>
References: <53905594d284f_71f12992fc6a@nysa.notmuch>
 <20140605133747.GB2942@dhcp22.suse.cz>
 <CAMP44s1kk8PyMd603g0C9yvHuuUZXzwwNQHpM8Abghvc_Os-SQ@mail.gmail.com>
 <20140606091620.GC26253@dhcp22.suse.cz>
 <CAMP44s2K-kZ8yLC3NPbpO9Z9ykQeySXW+cRiZ_NpLUMzDuiq9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2K-kZ8yLC3NPbpO9Z9ykQeySXW+cRiZ_NpLUMzDuiq9g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-06-14 05:33:28, Felipe Contreras wrote:
> On Fri, Jun 6, 2014 at 4:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Mel has a nice systemtap script (attached) to watch for stalls. Maybe
> > you can give it a try?
> 
> Is there any special configurations I should enable?

You need debuginfo and systemtap AFAIK. I haven't used this script
myself.
-- 
Michal Hocko
SUSE Labs
