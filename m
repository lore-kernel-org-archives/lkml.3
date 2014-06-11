Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaFKNGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:06:13 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58173 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaFKNGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:06:12 -0400
Date: Wed, 11 Jun 2014 14:05:58 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] Kernel does not boot on EeePC
Message-ID: <20140611130558.GA7173@sucs.org>
References: <20140608090223.GA8703@sucs.org>
 <20140609122616.124ebe43@thinkpad>
 <20140611061624.GA12132@sucs.org>
 <20140611144846.4a55410a@nial.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611144846.4a55410a@nial.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:48:46PM +0200, Igor Mammedov wrote:
> On Wed, 11 Jun 2014 07:16:24 +0100
> Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> 
> > It basically gives up just before Initializing CPU#0. The following is
> > an approximation of the boot messages that I see on the screen (the
> > early ones are gone before I can eyeball them so this is a blend of a
> > previous dmesg and what I see on the screen during a failure):
> Thanks for answer,
> 
> I've overlooked nonsmp case when testing where no one sets
> cpu_callout_mask for boot CPU and as result kernel hangs in cpu_init()

What gave you the tip off?

Additionally, does that also mean Ingo's test stand doesn't run nonsmp
kernels?

-- 
Sitsofe | http://sucs.org/~sits/
