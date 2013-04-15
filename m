Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494Ab3DOThp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:37:45 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:37360 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3DOThn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:37:43 -0400
Message-ID: <1366054656.4124.14.camel@thor.lan>
Subject: Re: [ 27/27] tty: dont deadlock while flushing workqueue
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Bryan ODonoghue <bryan.odonoghue.lkml@nexus-software.ie>
Date: Mon, 15 Apr 2013 15:37:36 -0400
In-Reply-To: <20130415024233.376898638@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
	 <20130415024233.376898638@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ -cc Alan Cox ]

On Sun, 2013-04-14 at 19:43 -0700, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> commit 852e4a8152b427c3f318bb0e1b5e938d64dcdc32 upstream.

Greg,

So many other serious error conditions are possible here, it seems
pointless to add this to 3.8-stable.

Regards,
Peter Hurley




