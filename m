Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3FQUPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:15:21 -0400
Received: from sam.nabble.com ([216.139.236.26]:38769 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab3FQUPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:15:19 -0400
Date: Mon, 17 Jun 2013 13:15:19 -0700 (PDT)
From: sergiocomputacao <sergiocomputacao@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1371500119311-668885.post@n7.nabble.com>
In-Reply-To: <5194046F.1030606@lwfinger.net>
References: <20130509115630.GC5111@gamma.logic.tuwien.ac.at> <518BC290.2040306@lwfinger.net> <20130515120801.GA24670@gamma.logic.tuwien.ac.at> <5194046F.1030606@lwfinger.net>
Subject: Re: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken
 at times
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the same card/problem.
The problem occurs when the connection is poor (in a n wireless network with
wpa2 enterprise). The only way to connect again is by doing rmmod rtl8192se
; modprobe rtl8192se

Thank you!



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/RTL-driver-for-RTL8191SEvB-and-or-wpa-supplicant-really-broken-at-times-tp647110p668885.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
