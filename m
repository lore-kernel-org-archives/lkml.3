Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913Ab3DHUDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:03:53 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:60319 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935872Ab3DHUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:03:52 -0400
Message-ID: <1365451422.3249.6.camel@thor.lan>
Subject: Re: [PATCH] tty: Fix race condition if flushing tty flip buffers
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ilya Zykov <linux@izyk.ru>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Mon, 08 Apr 2013 16:03:42 -0400
In-Reply-To: <20130408184804.GA4066@kroah.com>
References: <5149AFD0.8020604@izyk.ru>
	 <1363800043-21449-1-git-send-email-peter@hurleysoftware.com>
	 <20130408184804.GA4066@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 11:48 -0700, Greg Kroah-Hartman wrote:
> What tree is this against?  Does it need your other larger set of ldisc
> patches, or can it be applied without it?

This patch should apply cleanly against your tty-next tree without
dependencies on unapplied patchsets. I have not respun v3 of 'lockless
n_tty receive path' yet (mostly because I'm busy testing a lockless tty
buffer and currently writing a mostly-lockless echo).


