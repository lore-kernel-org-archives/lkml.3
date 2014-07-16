Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbaGPBBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:01:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33205 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993AbaGPBBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:01:44 -0400
Date: Tue, 15 Jul 2014 18:02:09 -0700
From: Olof Johansson <olof@lixom.net>
To: Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform/chrome: chromeos_laptop - Add a limit for
 deferred retries
Message-ID: <20140716010209.GB26638@quad.lixom.net>
References: <1405471391-27073-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405471391-27073-1-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:43:11PM -0700, Benson Leung wrote:
> Limit the number of times we allow deferred probing to attempt to add
> i2c devices. This will help with some device flakiness at probe time.
> For example, some touchpads and touchscreens may be in transition between
> bootloader and operational mode and may appear at neither address briefly.
> 
> Adapters, however, have no limit as it depends on when the i2c adapter driver
> module is loaded. The module may even be loaded manually by the user using
> modprobe or insmod.
> 
> By default, set MAX_I2C_DEVICE_DEFERALS to 5.
> 
> Based on this patch from the chromeos-kernel :
> https://chromium-review.googlesource.com/168130
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>

Applied, thanks.


-Olof
