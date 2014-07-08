Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaGHO4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:56:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20066 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539AbaGHO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:56:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2E/2vZo7rbbIKmvVwn2CqRT/bKsg+1Ik=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6D2E45A5664
Date: Tue, 8 Jul 2014 10:56:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jon Loeliger <loeliger@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: Questions About a Semi-Soft irqchip Device
Message-ID: <20140708145639.GD13433@titan.lakedaemon.net>
References: <CAJgR-Bi2HX+aYVabaFLyu9QAnAS4RmQ7DvBtDHOawkfi08zycA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJgR-Bi2HX+aYVabaFLyu9QAnAS4RmQ7DvBtDHOawkfi08zycA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon,

On Tue, Jul 08, 2014 at 09:02:14AM -0500, Jon Loeliger wrote:
> My IP block provides software-assignable interrupts.  That
> is, I have a large pool of interrupt sources, and a large pool
> of interrupt bits in the controller, but they are not physically
> tied together. Instead they are assigned by some driver as it
> initializes and allocates resources.  This, I think, means that
> I can not describe the interrupt  bindings in the DTS file.

Please take a look at the crossbar driver.  It's had quite a bit of
cleanup this cycle, so you may way to look at

  git://git.infradead.org/users/jcooper/linux.git irqchip/crossbar

It sounds very similar.

thx,

Jason.
