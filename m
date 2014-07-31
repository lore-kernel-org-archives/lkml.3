Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaGaCDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:03:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50104 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751277AbaGaCDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:03:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] irq: Warn when shared interrupts do not match on NO_SUSPEND
Date: Thu, 31 Jul 2014 04:22:11 +0200
Message-ID: <1994397.YOcQsPY00D@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <tip-4fae4e7624653ef498d0e2a38f00620b9701ab04@git.kernel.org>
References: <20140724133921.GY6758@twins.programming.kicks-ass.net> <tip-4fae4e7624653ef498d0e2a38f00620b9701ab04@git.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thursday, July 24, 2014 08:36:36 AM tip-bot for Peter Zijlstra wrote:
> Commit-ID:  4fae4e7624653ef498d0e2a38f00620b9701ab04
> Gitweb:     http://git.kernel.org/tip/4fae4e7624653ef498d0e2a38f00620b9701ab04
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Thu, 24 Jul 2014 15:39:21 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 24 Jul 2014 17:32:56 +0200
> 
> irq: Warn when shared interrupts do not match on NO_SUSPEND

Please revert this one as it is likely to break existing stuff (I'm mostly
worried about the ACPI interrupt, but also about a number of drivers that have
been using NO_SUSPEND along with SHARED for quite some time).

Rafael

