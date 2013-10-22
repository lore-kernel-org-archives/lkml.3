Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3JVPMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:12:37 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:45526 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab3JVPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:12:36 -0400
Date: Tue, 22 Oct 2013 15:12:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Sander Eikelenboom <linux@eikelenboom.it>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at mm/slub.c:3338!  RIP  [<ffffffff8117912c>]
 kfree+0x20c/0x210
In-Reply-To: <13810431525.20131020200555@eikelenboom.it>
Message-ID: <00000141e0b97e8b-1c313e97-5b79-4a5f-a013-0bbb5bd1f7e5-000000@email.amazonses.com>
References: <13810431525.20131020200555@eikelenboom.it>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Oct 2013, Sander Eikelenboom wrote:

> With i 3.12.0-rc6 kernel i encounterd this splat:

Likely some slab object got corrupted.

Please enable debugging by either specifying slub_debug on the kernel
command line or enabling CONFIG_SLUB_DEBUG_ON

