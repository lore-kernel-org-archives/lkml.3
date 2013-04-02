Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3DBTUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:20:46 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56289 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab3DBTUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:20:44 -0400
Date: Tue, 2 Apr 2013 12:20:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] THP: Use explicit memory barrier
In-Reply-To: <20130402003746.GA30444@blaptop>
Message-ID: <alpine.DEB.2.02.1304021215250.21661@chino.kir.corp.google.com>
References: <1364773535-26264-1-git-send-email-minchan@kernel.org> <alpine.DEB.2.02.1304011634530.21603@chino.kir.corp.google.com> <20130402003746.GA30444@blaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Minchan Kim wrote:

> Yes and Peter pointed out further step.
> Thanks for pointing out.
> Not that I know that Andrea alreay noticed it, I don't care about this
> patch.
> 

Andrea, do you have time to send

c08e0c9ee786 ("thp: add memory barrier to __do_huge_pmd_anonymous_page")
b08d75a595ec ("thp: document barrier() in wrprotect THP fault path")

from the master branch of aa.git to Andrew?  I would do it, but one isn't 
signed-off in your tree.
