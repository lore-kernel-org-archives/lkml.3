Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3JRW6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:58:45 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53331 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3JRW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:58:43 -0400
Date: Fri, 18 Oct 2013 15:58:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [bug] get_maintainer.pl incomplete output
In-Reply-To: <1382069821.22110.168.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1310181557020.20283@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com> <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com> <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org> <1382069821.22110.168.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Joe Perches wrote:

> Try this:
> 
> It adds authored/lines_added/lines_deleted to rolestats
> 
> For instance:
> 
> $ ./scripts/get_maintainer.pl -f mm/vmpressure.c
> Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%,authored:3/7=43%,removed_lines:15/21=71%)
> Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%,authored:3/7=43%,added_lines:22/408=5%,removed_lines:6/21=29%)
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> Anton Vorontsov <anton.vorontsov@linaro.org> (authored:1/7=14%,added_lines:374/408=92%)
> linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> linux-kernel@vger.kernel.org (open list)
> 
> I haven't tested it much.
> 

This looks good, thanks very much!  I'm not sure how useful the 
removed_lines stat is, but perhaps it can be useful for someone to chime 
in if someone proposes a patch that includes support that had already been 
removed.

Once it's signed off, feel free to add

	Acked-by: David Rientjes <rientjes@google.com>

Thanks again.
