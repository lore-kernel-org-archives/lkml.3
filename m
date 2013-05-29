Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab3E2SOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964985Ab3E2SOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:14:11 -0400
Message-ID: <51A64571.5050804@redhat.com>
Date: Wed, 29 May 2013 14:14:09 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: len.brown@kernel.org
Subject: Re: [RESEND 2] [PATCH 0/2] Rewrite power limit notification interrupt
 handling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

>The "Power Limit Notification" (X86_FEATURE_PLN) was added in Sandy Bridge
>to give the OS the option of knowing when the package has reached
>a configured power threshold.

>printk(KERN_CRIT "CPU%d: %s power limit notification (total events = %lu)
>printk(KERN_INFO "CPU%d: %s power limit normal\n"

I'm seeing this on a widening number of systems, mostly newer Intel systems.

>However, these events are quite routine on some systems under some conditions,
>alarming customers and provoking un-necessary customer support calls.

The idea that these are "routine" just doesn't make sense to me.  Either this
warning is firing for a valid reason or it isn't.  If it isn't then the question
remains -- why is it firing?  Is it because of buggy FW or is something
actually wrong with the hardware?

P.
