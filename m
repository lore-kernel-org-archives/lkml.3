Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaBJIOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:14:07 -0500
Received: from mx.ungleich.ch ([77.109.138.221]:41471 "EHLO mx.ungleich.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaBJIOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:14:03 -0500
Date: Mon, 10 Feb 2014 08:35:13 +0100
From: Nico Schottelius <nico-linux-20149210@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: nico-linux-20149210@schottelius.org
Subject: Support for automatic screen rotation on Lenovo Yogo 2 Pro
Message-ID: <20140210073513.GE2792@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20149210@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: artist (Linux 3.12.9-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning hackers,

The screen on the Lenovo Yoga 2 Pro can rotate up to 180 degrees and it would be awesome
if we could rotate it automatically under Linux. xrandr can already rotate it, what is missing 
is an event that we can trigger on. 

Is there any way to find out 
    a) if the screen is opened for more than 90 degrees?
    a) what the opening angle of the screen is?

I guess there must be support somewhere, as it is supposed to happen
automatically under windows. [1]

I am still facing the problem that there are no keycodes present for
some keys [0] - if you have a hint for this problem, I am wondering 
if anyone has a pointer on how to solve one of these issues?

Cheers,

Nico

[0] https://lkml.org/lkml/2014/1/28/251
[1] I have never tried windows on this device, but from the forums and
    marketing I assume it works trigger based on the opening angle.



-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
