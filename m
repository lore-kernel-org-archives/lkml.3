Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaGaCGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:06:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62028 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751533AbaGaCGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:06:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: tglx@linutronix.de
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, aubrey.li@linux.intel.com,
        gnomes@lxorguk.ukuu.org.uk, dmitry.torokhov@gmail.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] PM / sleep / irq: Do not suspend wakeup interrupts
Date: Thu, 31 Jul 2014 04:24:50 +0200
Message-ID: <1808876.udUlStYjHN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <tip-d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1@git.kernel.org>
References: <4679574.kGUnqAuNl9@vostro.rjw.lan> <tip-d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1@git.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tuesday, July 15, 2014 04:01:10 AM tip-bot for Rafael J. Wysocki wrote:
> Commit-ID:  d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1
> Gitweb:     http://git.kernel.org/tip/d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1
> Author:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> AuthorDate: Thu, 10 Jul 2014 23:37:54 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 15 Jul 2014 12:57:26 +0200
> 
> PM / sleep / irq: Do not suspend wakeup interrupts

Please revert this one as it will introduce a problem with shared interrupts
analogous to the one that the handling of IRQF_NO_SUSPEND has.

Rafael

