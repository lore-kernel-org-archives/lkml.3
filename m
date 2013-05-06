Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3EFItJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:49:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:51120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3EFItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:49:07 -0400
Date: Mon, 6 May 2013 10:48:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tip-bot for Thomas Gleixner <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu
 down
In-Reply-To: <5186B8F1.9090105@redhat.com>
Message-ID: <alpine.LFD.2.02.1305061048190.3095@ionos>
References: <alpine.LFD.2.02.1305031451561.2886@ionos> <tip-ae7868e241c015aadc8632d9fe633a102a5918f6@git.kernel.org> <5186B8F1.9090105@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 May 2013, Prarit Bhargava wrote:
> Whoa -- I thought I said I'll test this first.  It doesn't work :( so that means
> something else is wrong ... I'm in the middle of debug ATM.

I pushed it out accidentaly. New fixed and working version is uploaded already
