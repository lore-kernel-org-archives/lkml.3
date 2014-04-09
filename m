Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaDIMl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:41:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37238 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDIMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:41:56 -0400
Date: Wed, 9 Apr 2014 13:41:21 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Eric Ernst <eric.ernst@intel.com>
Subject: Re: [PATCH 1/2] watchdog: add Intel MID watchdog driver support
Message-ID: <20140409134121.7ce4e7a4@alan.etchedpixels.co.uk>
In-Reply-To: <5344919E.9030708@roeck-us.net>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
	<1396990744-10695-2-git-send-email-david.a.cohen@linux.intel.com>
	<5344919E.9030708@roeck-us.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2014 17:17:34 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On 04/08/2014 01:59 PM, David Cohen wrote:
> > Add initial Intel MID watchdog driver support.
> >
> > This driver is an initial implementation of generic Intel MID watchdog
> > driver. Currently it supports Intel Merrifield platform.
> 
> How does this compare with the existing SCU watchdog driver
> (intel_scu_watchdog) ? The watchdog IPC message (0xf8) seems
> to be the same, so there must be at least some overlap.
> Would it be possible to have just one watchdog driver
> serving the different SCU based devices ?

There are enough differences that we'd end up with one spaghetti driver
full of conditionals rather than two simple clean drivers.

Alan
