Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3FHBpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:45:12 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56425 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3FHBpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:45:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] Add TI-Nspire irqchip support
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <20130531120647.149FF3E0901@localhost>
Date: Sat, 8 Jun 2013 11:45:00 +1000
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C5349A0A-2BEA-4C8B-B7A0-E8F21A922674@gmail.com>
References: <89D06030-E27E-445D-BBB8-45A47CA6C892@gmail.com> <alpine.LFD.2.02.1305301639560.2905@ionos> <20130531120647.149FF3E0901@localhost>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 31/05/2013, at 10:06 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> 
> Hi Daniel,
> 
> What is the SoC used in the Nspire? Is it something custom for the
> calculator, or does it use an existing SoC?

It seems to be a custom SoC from what I can see.

> I'm just surprised that this
> device needs a new interrupt controller driver rather than one of the
> drivers that is already in the tree.

I had a brief look in the other driver code and there doesn't seem to be a existing driver for this interrupt controller.

> 
> If it is a new device, then that is fine, but you should follow the
> discussion that Thomas pointed you at below.
> 
> g.
> 

Cheers,
Daniel Tang