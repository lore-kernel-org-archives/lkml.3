Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaIYOCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:02:51 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47754 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIYOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:02:50 -0400
Date: Thu, 25 Sep 2014 16:02:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Masanari Iida <standby24x7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sasha.levin@oracle.com,
        linux-mm@kvack.org
Subject: Re: [linux-next] mm/debug.c compile failure with CONFIG_MEMCG not set
Message-ID: <20140925140246.GC11080@dhcp22.suse.cz>
References: <CALLJCT0YKkg=PZN1i4eOEWdJoLE8oAyTAk0OmRHLOGRstqk4MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALLJCT0YKkg=PZN1i4eOEWdJoLE8oAyTAk0OmRHLOGRstqk4MQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-09-14 22:55:24, Masanari Iida wrote:
> As of linux-next 20140925, if I don't set CONFIG_MEMCG,
> the compile failed with following error.
> 
> mm/debug.c: In function ‘dump_mm’:
> mm/debug.c:169:1183: error: ‘const struct mm_struct’ has no member named ‘owner’
>   pr_emerg("mm %p mmap %p seqnum %d task_size %lu\n"
> 
> make[1]: *** [mm/debug.o] Error 1
> 
> If I set CONFIG_MEMCG, the compile succeed.
> 
> Reported-by: Masanari Iida <standby24x7@gmail.com>

This is already fixed in Andrew's tree:
http://marc.info/?l=linux-mm&m=141146435524579&w=2

-- 
Michal Hocko
SUSE Labs
