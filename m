Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3JQDvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:51:22 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46200 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JQDvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:51:20 -0400
Date: Wed, 16 Oct 2013 20:51:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [bug] get_maintainer.pl incomplete output
In-Reply-To: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

I haven't looked closely at scripts/get_maintainer.pl, but I recently 
wrote a patch touching mm/vmpressure.c and it doesn't list the file's 
author, Anton Vorontsov <anton.vorontsov@linaro.org>.

Even when I do scripts/get_maintainer.pl -f mm/vmpressure.c, his entry is 
missing and git blame attributs >90% of the lines to his authorship.

$ ./scripts/get_maintainer.pl -f mm/vmpressure.c 
Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%)
Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
"Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
linux-kernel@vger.kernel.org (open list)

Any ideas?
