Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaJAAMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:12:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:34109 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaJAAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:12:09 -0400
Date: Wed, 1 Oct 2014 02:11:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, hpa@zytor.com, davej@redhat.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Quark: Add legacy_cache_size and TLB comments
In-Reply-To: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1410010153590.4455@nanos>
References: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan,

On Wed, 1 Oct 2014, Bryan O'Donoghue wrote:

what are you trying to achieve by sending out patches faster than
anyone can review?

Doing this has an obvious outcome:

  1) The patches you whip up 10 seconds after the review hits your
     inbox are likely not to be well thought out. Neither are the
     changelogs.

     Just by skimming the lot I noticed at least two issues which you
     just mechanically fixed up without applying any thought. I'm not
     going to tell you, simply because you are starting to abuse and
     waste my time.

  2) Keeping #1 as your modus operandi will make sure that you get on
     the backlog list of reviewers and maintainers and in the worst
     case on the shitlist.

Thanks,

	tglx
