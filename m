Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3GTFnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 01:43:05 -0400
Received: from mail.sysmocom.de ([144.76.43.93]:28284 "EHLO mail.sysmocom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab3GTFnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 01:43:02 -0400
Date: Sat, 20 Jul 2013 07:43:00 +0200
From: Holger Hans Peter Freyther <holger@freyther.de>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/timer_list and weird behavior with dropbear
Message-ID: <20130720054300.GA29718@xiaoyu.lan>
References: <20130719152800.GA20792@xiaoyu.lan>
 <51E95F0B.6080703@sgi.com>
 <20130719170354.GE5902@xiaoyu.lan>
 <20130719203323.GA129438@asylum.americas.sgi.com>
 <20130719203707.GA149061@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719203707.GA149061@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:37:07PM -0500, Nathan Zimmer wrote:

> Forgot the patch last time.
> Sorry

yes, this appears to fix the problem I experience.


thanks
	holger
