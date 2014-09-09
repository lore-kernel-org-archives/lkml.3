Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaIIGWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:22:06 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53039 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaIIGWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:22:05 -0400
Message-ID: <540E9C88.9010200@monom.org>
Date: Tue, 09 Sep 2014 08:22:00 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Reset bandwith on task when switching from SCHED_DEADLINE
 away
References: <1409747397-23653-1-git-send-email-daniel.wagner@bmw-carit.de> <540DC7B2.6000000@arm.com>
In-Reply-To: <540DC7B2.6000000@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,

On 09/08/2014 05:13 PM, Juri Lelli wrote:
> thanks a lot for your patch. I'd actually have a slightly different fix
> for the same problem. I'm actually baking a small patchset that I should
> be able to release in the next few days. I'd say we could wait for that
> to happen and then discuss which approach is better, ok?

Sure, no problem. Probably I didn't fix all corner cases anyway.

cheers,
daniel
