Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaDQVqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:46:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:51919 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQVqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:46:13 -0400
Date: Thu, 17 Apr 2014 23:46:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Bohac <jbohac@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timer: prevent overflow in apply_slack
In-Reply-To: <20140417194215.GA10494@midget.suse.cz>
Message-ID: <alpine.DEB.2.02.1404172344420.22697@ionos.tec.linutronix.de>
References: <20140417194215.GA10494@midget.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Jiri Bohac wrote:

> Prevent overflow in the computation of timer expiry time inside
> apply_slack().

What's the impact of this overflow?

We don't want changelogs which describe what they do, we want them to
describe WHY and WHAT kind of problem the patch fixes.
 
Thanks,

	tglx
