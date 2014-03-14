Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaCNChF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:37:05 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44192 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbaCNChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:37:03 -0400
Message-ID: <1394764620.21721.56.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] procfs: make smp_affinity values 0644
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chema Gonzalez <chema@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2014 19:37:00 -0700
In-Reply-To: <1394762715-24272-1-git-send-email-chema@google.com>
References: <1394762715-24272-1-git-send-email-chema@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 19:05 -0700, Chema Gonzalez wrote:
> Includes:
> - /proc/irq/default_smp_affinity
> - /proc/irq/*/smp_affinity
> - /proc/irq/*/smp_affinity_list
> 
> Users can distill the same information by reading /proc/interrupts.
> 
> Signed-off-by: Chema Gonzalez <chema@google.com>
> ---

Seems good to me, but what about affinity_hint ?


