Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3JaIah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:30:37 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46644 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3JaIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:30:34 -0400
Date: Thu, 31 Oct 2013 01:30:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH RESEND v2] Input: add driver for Neonode zForce based
 touchscreens
Message-ID: <20131031083031.GA26810@core.coreip.homeip.net>
References: <201310301718.48650.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201310301718.48650.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 05:18:47PM +0100, Heiko Stübner wrote:
> This adds a driver for touchscreens using the zforce infrared
> technology from Neonode connected via i2c to the host system.
> 
> It supports multitouch with up to two fingers and tracking of the
> contacts in hardware.


Applied, thank you.

-- 
Dmitry
