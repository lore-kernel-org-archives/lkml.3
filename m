Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3JVP3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:29:13 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:43835 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3JVP3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:29:11 -0400
Date: Tue, 22 Oct 2013 17:29:05 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1248998992.20131022172905@eikelenboom.it>
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at mm/slub.c:3338!  RIP  [<ffffffff8117912c>] kfree+0x20c/0x210
In-Reply-To: <00000141e0b97e8b-1c313e97-5b79-4a5f-a013-0bbb5bd1f7e5-000000@email.amazonses.com>
References: <13810431525.20131020200555@eikelenboom.it> <00000141e0b97e8b-1c313e97-5b79-4a5f-a013-0bbb5bd1f7e5-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, October 22, 2013, 5:12:35 PM, you wrote:

> On Sun, 20 Oct 2013, Sander Eikelenboom wrote:

>> With i 3.12.0-rc6 kernel i encounterd this splat:

> Likely some slab object got corrupted.

> Please enable debugging by either specifying slub_debug on the kernel
> command line or enabling CONFIG_SLUB_DEBUG_ON


Well since it seems a "one timer" so i'm not very sure if and when i would encounter it again.
It seems "slub_debug" on the commandline would do the same, so i will run my VM with that for some time, see if triggers again.

--
Sander

