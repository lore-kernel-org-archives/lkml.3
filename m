Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3JaHoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:44:20 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42190 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3JaHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:44:18 -0400
Date: Thu, 31 Oct 2013 00:44:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] input: i8042 - add PNP modaliases
Message-ID: <20131031074413.GA14944@core.coreip.homeip.net>
References: <20130903193547.GA8150@srcf.ucam.org>
 <1378286856-6384-1-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378286856-6384-1-git-send-email-teg@jklm.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 11:27:36AM +0200, Tom Gundersen wrote:
> This allows the module to be autoloaded in the common case.
> 
> In order to work on non-PnP systems the module should be compiled in or loaded
> unconditionally at boot (c.f. modules-load.d(5)), as before.
> 
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Tom Gundersen <teg@jklm.no>

Applied, thank you.

-- 
Dmitry
