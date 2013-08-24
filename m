Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3HXX0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 19:26:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38030 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab3HXX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 19:26:34 -0400
Date: Sat, 24 Aug 2013 16:26:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ian Munsie <darkstarsword@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: apple: Add another device ID for the mid-2013
 Macbook Air
Message-ID: <20130824232630.GA4454@core.coreip.homeip.net>
References: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
 <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Sun, Aug 25, 2013 at 12:17:52AM +1000, Ian Munsie wrote:
> This patch adds a device ID found for mid-2013 Macbook Air 6,1 from
> lsusb:
> 
> Bus 001 Device 003: ID 05ac:0290 Apple, Inc.
> 
> Since IDs already exist for this generation Macbook air as WELLSPRING8,
> name this one WELLSPRING8A. This only adds an ANSI version since it's
> device ID is only one less than the existing WELLSPRING8 IDs.
> 
> Signed-off-by: Ian Munsie <darkstarsword@gmail.com>

Thank you for the patch!

Jiri, can I take it through my tree for 3.11?

Thanks.

-- 
Dmitry
