Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966Ab3D3QLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:11:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39419 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760331Ab3D3QLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:11:08 -0400
Message-ID: <517FED13.8090806@parallels.com>
Date: Tue, 30 Apr 2013 20:10:59 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: [PATCH 0/5] mm: Ability to monitor task memory changes (v4)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the resend and (while the iron is hot) the request for merge of
the implementation of the soft-dirty bit concept that should help to track
changes in user memory.

This set differs from what Andrew has sent recently in a single point --
the way pagemap entries' bits are reused (patch #5, and one hunk about
Documantation/ file in patch #4). Other places hasn't changed at all.

Thanks,
Pavel
