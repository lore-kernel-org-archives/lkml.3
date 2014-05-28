Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaE1OLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbaE1OLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:11:04 -0400
Date: Wed, 28 May 2014 14:10:51 +0000
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: linux-kernel@vger.kernel.org, nlopezcasad@logitech.com
Subject: Re: Logitech Unifying Receiver - power button not being reported?
Message-ID: <20140528141051.GA29629@mail.corp.redhat.com>
References: <20140526221905.GG3343@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140526221905.GG3343@hardeman.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On May 27 2014 or thereabouts, David Härdeman wrote:
> Hi,
> 
> the Logitech Unifying Receiver (i.e. the USB dongle that's used for e.g.
> the k400r wireless keyboard) does not seem to report any keyboard events
> for the power button (I can resume from suspend-to-ram since the dongle
> seems to do the right thing, but I can't do the opposite since no event
> seems to be generated).

I can definitively confirm that the power button of my k750 works (it
costed me a hard reboot :-P )

Can you send us the output of "evemu-record" as root when you press the
button. If nothing comes out, some dmesg messages should be present with
the action to take.

Cheers,
Benjamin

> 
> Is this a known limitation? Something that can be fixed? Is there
> something I've overlooked?
> 
> -- 
> David Härdeman
