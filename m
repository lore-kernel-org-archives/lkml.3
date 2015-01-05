Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbbAEWlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:41:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:41:45 -0500
Date: Mon, 5 Jan 2015 14:41:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: Restore alarm after resume
Message-Id: <20150105144144.46a4792e90e5800b1d865cdd@linux-foundation.org>
In-Reply-To: <1419275979-24307-1-git-send-email-matthew.garrett@nebula.com>
References: <1419275979-24307-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014 19:19:39 +0000 Matthew Garrett <matthew.garrett@nebula.com> wrote:

> Some platform firmware may interfere with the RTC alarm over suspend,
> resulting in the kernel and hardware having different ideas about system state
> but also potentially causing problems with firmware that assumes the OS will
> clean this case up. This patch saves the RTC alarm state on suspend and will
> restore it on resume if the alarm has not yet fired - if it has, it will clear
> the RTC alarm.

There's not really enough info here for me to decide which kernel
version(s) need the patch.  Can we please expand on "some"?  Any
suggestions regarding the importance/timing of the fix?


