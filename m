Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaIVOnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaIVOnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:43:32 -0400
Message-ID: <54203572.8020406@redhat.com>
Date: Mon, 22 Sep 2014 10:42:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/numa: kill the wrong/dead TASK_DEAD check in task_numa_fault()
References: <20140921194743.GA30114@redhat.com>
In-Reply-To: <20140921194743.GA30114@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/21/2014 03:47 PM, Oleg Nesterov wrote:
> current->state == TASK_DEAD means that the task is doing its last 
> schedule(), page fault is obviously impossible at this stage.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUIDVyAAoJEM553pKExN6D50oH/A5RpFUhx5zsDYgFjyq071+n
NYgwgy6Nr6DDkmfEGtRePxQY7CmysKCTWdPzAFxmvhaFfOg2zP+P7uh85/lbIYXM
7ATj4yO8u3Loa8zdz+VjwrOR0lJr/Y/nsjQC0q+50oNM0pwFC+HPuSPTrpz4o+HB
ReeZ6BKNtFoiC5RfR0XpNHk4ozwT5qW2oCDEIT6bsMQiV0413CXksHFg6Flz7Acb
2EFCzwY2BgfKRawGR6e4Q09UZ0aG1gW9RkLkUuIWlmbOHiMzduLCIKQNCZaXTgVn
xVJcsgdANnQk1BGSU5rozqtlDUmRoKq3teXlE00CcJEEfzUrUHMw0HYZ62xbQ+s=
=fg3H
-----END PGP SIGNATURE-----
