Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaGPKAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:00:49 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37243 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaGPKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:00:46 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1405504838.17757.2.camel@nuvo>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
From: Bastien Nocera <hadess@hadess.net>
To: Patrik Fimml <patrikf@chromium.org>
Cc: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dtor@google.com>, Benson Leung <bleung@google.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 12:00:38 +0200
In-Reply-To: <20140716013206.GA13409@google.com>
References: <20140716013206.GA13409@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.3 (3.12.3-3.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 18:32 -0700, Patrik Fimml wrote:
> (Re-sending with correct mailing list addresses.)
> 
> Hi,
> 
> When the lid of a laptop is closed, certain devices can no longer
> provide interesting input or will even produce bogus input, such as:
<snip>
> It's somewhat difficult to get the semantics right, since handles to
> such devices might still be open. It might be easier to implement
> behavior specific to device classes. On the other hand, it would be nice
> to have a uniform way of shutting devices down, and not introduce
> another possible path for a device to enter a power-saving state.
> 
> Rafael, can you give us your opinion on this?

Ditto the "tablet mode" of some devices such as the Thinkpad X41, or the
newer Lenovo Yoga, which should have their keyboards and touchpads
disabled.

If we used something like UPower to enable/disable those inaccessible
devices, we'd need a way of enumerating which devices won't be
accessible in those modes. Turning them off and back on should be easy
enough.

Cheers

