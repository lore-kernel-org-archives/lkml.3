Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3C1WbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:31:23 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37921 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3C1WbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:31:22 -0400
Message-ID: <5154C4B6.102@suse.cz>
Date: Thu, 28 Mar 2013 23:31:18 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130325090758.GO2154@dhcp22.suse.cz> <51501545.50908@suse.cz>
In-Reply-To: <51501545.50908@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 10:13 AM, Jiri Slaby wrote:
> BTW I very pray this will fix also the issue I have when I run ltp tests
> (highly I/O intensive, esp. `growfiles') in a VM while playing a movie
> on the host resulting in a stuttered playback ;).

No, this is still terrible. I was now updating a kernel in a VM and had
problems to even move with cursor. There was still 1.2G used by I/O cache.

thanks,
-- 
js
suse labs
