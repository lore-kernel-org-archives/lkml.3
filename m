Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbaE2Gog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:44:36 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:56553 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbaE2God convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 29 May 2014 02:44:33 -0400
Message-Id: <5386E55F02000078000B524F@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Thu, 29 May 2014 07:44:31 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <linux@horizon.com>, <tim.c.chen@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
References: <5386596402000078000B51F8@mail.emea.novell.com>
 <20140528214703.26413.qmail@ns.horizon.com>
In-Reply-To: <20140528214703.26413.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "George Spelvin" <linux@horizon.com> 05/28/14 11:47 PM >>>
>Jan Beulich <jbeulich@suse.com> wrote:
>> "George Spelvin" <linux@horizon.com> 05/28/14 4:40 PM
>>> Jan: Is support for SLE10's pre-2.18 binutils still required?
>>> Your PEXTRD fix was only a year ago, so I expect, but I wanted to ask.
>
>> I'd much appreciate if I would be able to build the kernel that way for
>> another while.
>
>Does it matter that the code I'm working on is 64-bit only?

No.

>It aready
>uses crc32q instruction (added with SSE4.2) with no assembler workarounds,
>so I figure pmovzxdq (part of SSE 4.1) doesn't make it any worse.

If that's the case, then adding another (earlier) one shouldn't be an issue.

Jan

