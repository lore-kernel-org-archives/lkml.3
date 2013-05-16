Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3EPOHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:07:38 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:59761 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3EPOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:07:33 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [Resned/PATCHv5 0/2] Serial fixes
References: <1368632138-31695-1-git-send-email-sourav.poddar@ti.com>
Date: Thu, 16 May 2013 07:07:29 -0700
In-Reply-To: <1368632138-31695-1-git-send-email-sourav.poddar@ti.com> (Sourav
	Poddar's message of "Wed, 15 May 2013 21:05:36 +0530")
Message-ID: <87ip2jt3vi.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> Hi Greg,
>
> I have rebased this patch series on top of 3.10-rc1.

Thanks for the rebase.  

Once Greg queues these, I will queue the OMAP specific pieces (which are
not strictly dependent on the core changes.)

Kevin
