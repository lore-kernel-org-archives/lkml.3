Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaJ2TOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:14:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbaJ2TOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:14:42 -0400
Date: Wed, 29 Oct 2014 12:14:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-Id: <20141029121442.6b6ca116973be0ff8d78c7c2@linux-foundation.org>
In-Reply-To: <20141029125005.GB8823@localhost>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
	<1414397368-26480-1-git-send-email-johan@kernel.org>
	<20141027154031.4492ea11d401045ca04a3ff8@linux-foundation.org>
	<20141028083633.GM2006@localhost>
	<20141029125005.GB8823@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 13:50:05 +0100 Johan Hovold <johan@kernel.org> wrote:

> On Tue, Oct 28, 2014 at 09:36:33AM +0100, Johan Hovold wrote:
> > On Mon, Oct 27, 2014 at 03:40:31PM -0700, Andrew Morton wrote:
> > > On Mon, 27 Oct 2014 09:09:28 +0100 Johan Hovold <johan@kernel.org> wrote:
> 
> > But in general, how do you want to handle updates to a single patch in a
> > series you already have in your tree? Do you prefer a proper
> > incremental-fix patch (with commit message), just an updated single
> > patch, or a resend of the whole series?
> 
> How should I best send the updated patch? Can you just replace the
> current three incremental patches:
> 
> 	rtc-omap-add-support-for-pmic_power_en.patch
> 	rtc-omap-add-support-for-pmic_power_en-v3.patch
> 	rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
> 
> that you have in your tree, with a single new v4 which adds a more
> elaborate comment?

Yep, that works.  I'll almost always turn the new patch into an
incremental, mainly so that I (and others) can see what was changed.
