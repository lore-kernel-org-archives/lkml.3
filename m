Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3AOTU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:20:58 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:54641 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3AOTU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:20:57 -0500
X-Remote-IP: 213.191.128.133
Date: Tue, 15 Jan 2013 20:20:51 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Clayton <andrew@digital-domain.net>,
        Rik van Riel <riel@redhat.com>
References: <alpine.LNX.2.00.1301152010040.14768@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301152010040.14768@pobox.suse.cz>
Message-ID: <50F5AC13.1040508@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130115 #9067708, check: 20130115 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 41509 [Jan 15 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2013 20:12, Jiri Kosina wrote:
> Commit 1b963c81b1 ("lockdep, rwsem: provide down_write_nest_lock()")
> contains a bug in a codepath when CONFIG_DEBUG_LOCK_ALLOC is disabled,
> which causes down_read() to be called instead of down_write() by mistake
> on such configurations. Fix that.
>
> Reported-by: Andrew Clayton <andrew@digital-domain.net>
> Reported-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
> Tested-by: Andrew Clayton <andrew@digital-domain.net>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Reported-and-tested-by: Zlatko Calusic <zlatko.calusic@iskon.hr>

kvm starts just fine now. Thanks Jiri!

-- 
Zlatko
