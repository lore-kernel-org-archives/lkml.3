Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3E0R7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:59:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab3E0R7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:59:18 -0400
Message-ID: <51A39EF0.5000206@redhat.com>
Date: Mon, 27 May 2013 13:59:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/4] ipc/sem.c: Rename try_atomic_semop() to perform_atomic_semop(),
 docu update
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369559335-13491-5-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1369559335-13491-5-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 05:08 AM, Manfred Spraul wrote:
> Final cleanup: Some minor points that I noticed while writing the
> previous 3 patches
>
> 1) The name try_atomic_semop() is misleading: The function performs the
>     operation (if it is possible).
>
> 2) Some documentation updates.
>
> No real code change, a rename and documentation changes.

I like this.

> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

