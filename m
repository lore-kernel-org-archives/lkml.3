Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbbASADr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:03:47 -0500
Received: from server.atrad.com.au ([150.101.241.2]:41762 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbASADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:03:45 -0500
Date: Mon, 19 Jan 2015 10:33:08 +1030
From: Jonathan Woithe <jwoithe@just42.net>
To: Darren Hart <dvhart@infradead.org>
Cc: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fujitsu-laptop: use FB_BLANK_* constants
Message-ID: <20150119000307.GA20491@marvin.atrad.com.au>
References: <0150118191421.GJ56582@vmdeb7>
 <1421609326-3610-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
 <20150118222232.GA64157@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118222232.GA64157@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-MIMEDefang-action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 02:22:32PM -0800, Darren Hart wrote:
> On Sun, Jan 18, 2015 at 08:28:46PM +0100, Michael Karcher wrote:
> > Replace the magic numbers in fujitsu-laptop.c by the appropriate FB_BLANK
> > constants, as indicated by the comment for backlight_properties.power in
> > include/linux/backlight.h.
> > 
> > Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> 
> Thanks Michael, queued for 3.20.

Acked-by: Jonathan Woithe <jwoithe@just42.net>
