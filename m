Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaEZWTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:19:10 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:34069 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbaEZWTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:19:09 -0400
Date: Tue, 27 May 2014 00:19:05 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: benjamin.tissoires@redhat.com, nlopezcasad@logitech.com
Subject: Logitech Unifying Receiver - power button not being reported?
Message-ID: <20140526221905.GG3343@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	benjamin.tissoires@redhat.com, nlopezcasad@logitech.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the Logitech Unifying Receiver (i.e. the USB dongle that's used for e.g.
the k400r wireless keyboard) does not seem to report any keyboard events
for the power button (I can resume from suspend-to-ram since the dongle
seems to do the right thing, but I can't do the opposite since no event
seems to be generated).

Is this a known limitation? Something that can be fixed? Is there
something I've overlooked?

-- 
David Härdeman
