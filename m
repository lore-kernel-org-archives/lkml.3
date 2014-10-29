Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbaJ2MxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:53:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58078 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbaJ2MxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:53:14 -0400
Date: Wed, 29 Oct 2014 13:50:05 +0100
From: Johan Hovold <johan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-ID: <20141029125005.GB8823@localhost>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
 <1414397368-26480-1-git-send-email-johan@kernel.org>
 <20141027154031.4492ea11d401045ca04a3ff8@linux-foundation.org>
 <20141028083633.GM2006@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028083633.GM2006@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:36:33AM +0100, Johan Hovold wrote:
> On Mon, Oct 27, 2014 at 03:40:31PM -0700, Andrew Morton wrote:
> > On Mon, 27 Oct 2014 09:09:28 +0100 Johan Hovold <johan@kernel.org> wrote:

> But in general, how do you want to handle updates to a single patch in a
> series you already have in your tree? Do you prefer a proper
> incremental-fix patch (with commit message), just an updated single
> patch, or a resend of the whole series?

How should I best send the updated patch? Can you just replace the
current three incremental patches:

	rtc-omap-add-support-for-pmic_power_en.patch
	rtc-omap-add-support-for-pmic_power_en-v3.patch
	rtc-omap-add-support-for-pmic_power_en-v3-fix.patch

that you have in your tree, with a single new v4 which adds a more
elaborate comment?

Thanks,
Johan
