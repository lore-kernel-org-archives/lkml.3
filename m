Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbAMM3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:29:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:44704 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbAMM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:29:43 -0500
Date: Tue, 13 Jan 2015 13:29:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org, davidel@xmailserver.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] timerfd: export defines to userspace
In-Reply-To: <1419991019-5139-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.2.11.1501131329040.5526@nanos>
References: <1419991019-5139-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014, Mike Frysinger wrote:

> Since userspace is expected to call timerfd syscalls directly with these
> flags/ioctls, make sure we export them so they don't have to duplicate
> the values themselves.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
