Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3DBO70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:59:26 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:42083 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3DBO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:59:24 -0400
Message-ID: <515AF27C.2060206@suse.cz>
Date: Tue, 02 Apr 2013 17:00:12 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
References: <20130402142717.GH32241@suse.de>
In-Reply-To: <20130402142717.GH32241@suse.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:27 PM, Mel Gorman wrote:
> I'm testing a page-reclaim-related series on my laptop that is partially
> aimed at fixing long stalls when doing metadata-intensive operations on
> low memory such as a git checkout. I've been running 3.9-rc2 with the
> series applied but found that the interactive performance was awful even
> when there was plenty of free memory.
> 
> I activated a monitor from mmtests that logs when a process is stuck for
> a long time in D state and found that there are a lot of stalls in ext4.
> The report first states that processes have been stalled for a total of
> 6498 seconds on IO which seems like a lot. Here is a breakdown of the
> recorded events.

Just a note that I am indeed using ext4 on the affected machine for all
filesystems I have except for an efi partition...

-- 
js
suse labs
