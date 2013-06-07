Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3FGK1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:27:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59418 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab3FGK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:27:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: shuox.liu@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, pavel@ucw.cz,
        len.brown@intel.com, gregkh@linuxfoundation.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 0/2] Run callback of device_prepare/complete consistently
Date: Fri, 07 Jun 2013 12:36:12 +0200
Message-ID: <2482951.doztFClhed@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 04:20:30 PM shuox.liu@intel.com wrote:
> dpm_run_callback is used in other stages of power states changing.
> It provides debug info message and time measurement when call these
> callback. We also want to benefit ->prepare and ->complete.
> 
> [PATCH 1/2] PM: use dpm_run_callback in device_prepare
> [PATCH 2/2] PM: add dpm_run_callback_void and use it in device_complete

Is this an "Oh, why don't we do that?" series, or is it useful for anything
in practice?  I'm asking, because we haven't added that stuff to start with
since we didn't see why it would be useful to anyone.

And while patch [1/2] reduces the code size (by 1 line), so I can see some
(tiny) benefit from applying it, patch [2/2] adds more code and is there any
paractical reason?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
