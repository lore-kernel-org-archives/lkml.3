Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3AOTPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3AOTPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:15:43 -0500
Message-ID: <50F5AAAC.10205@redhat.com>
Date: Tue, 15 Jan 2013 14:14:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Clayton <andrew@digital-domain.net>,
        Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: Re: [PATCH] lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC
References: <alpine.LNX.2.00.1301152010040.14768@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301152010040.14768@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 02:12 PM, Jiri Kosina wrote:
> Commit 1b963c81b1 ("lockdep, rwsem: provide down_write_nest_lock()")
> contains a bug in a codepath when CONFIG_DEBUG_LOCK_ALLOC is disabled,
> which causes down_read() to be called instead of down_write() by mistake
> on such configurations. Fix that.
>
> Reported-by: Andrew Clayton <andrew@digital-domain.net>
> Reported-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
> Tested-by: Andrew Clayton <andrew@digital-domain.net>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
