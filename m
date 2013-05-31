Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3EaBB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:01:29 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:34360 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3EaBBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <51A5FE2D.9080403@synopsys.com>
References: <1361471962-25164-3-git-send-email-vgupta@synopsys.com>
	<51A5FE2D.9080403@synopsys.com>
Date: Fri, 31 May 2013 05:01:22 +0400
Message-ID: <CAMo8BfLWuTo8v83QU1s1AkoGJXmYDUQ-bnFFOVeTgjRPJzG4HA@mail.gmail.com>
Subject: Re: [PATCH 2/2] xtensa: Flat DeviceTree copy not future-safe
From: Max Filippov <jcmvbkbc@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On Wed, May 29, 2013 at 5:10 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> Hi Max,
>
> This patch - acked by you then, got lost in the mist of time. Care to take it in
> via xtensa tree for 3.11

Oops. Thanks for the reminder. Took it to the xtensa-fixes branch.

> -------- Original Message --------
> Subject: [PATCH 2/2] xtensa: Flat DeviceTree copy not future-safe
> Date: Fri, 22 Feb 2013 00:09:22 +0530
> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> To: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
> Max Filippov <jcmvbkbc@gmail.com>, Marc Gauthier <marc@tensilica.com>
> CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-xtensa@linux-xtensa.org>,
> <linux-kernel@vger.kernel.org>
> Newsgroups: gmane.linux.kernel
> References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>

-- 
Thanks.
-- Max
