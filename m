Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaFIN6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:58:13 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38835 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaFIN6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:58:09 -0400
Message-ID: <5395BD6D.1060907@suse.cz>
Date: Mon, 09 Jun 2014 15:58:05 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.12 068/146] revert "mm: vmscan: do not swap anon pages
 just because free+file is low"
References: <cover.1402303820.git.jslaby@suse.cz> <245fd39e32a9e849fab4120e09950bb073b8982e.1402303821.git.jslaby@suse.cz> <20140609133531.GD2878@cmpxchg.org>
In-Reply-To: <20140609133531.GD2878@cmpxchg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 03:35 PM, Johannes Weiner wrote:
> On Mon, Jun 09, 2014 at 10:50:03AM +0200, Jiri Slaby wrote:
>> From: Johannes Weiner <hannes@cmpxchg.org>
>>
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ===============
>>
>> commit 623762517e2370be3b3f95f4fe08d6c063a49b06 upstream.
>>
>> This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages
>> just because free+file is low") because it introduced a regression in
> 
> That commit never made it into 3.12, please don't merge the revert as
> it would introduce duplicate code.

Ugh, now dropped. Thanks for noticing!

-- 
js
suse labs
