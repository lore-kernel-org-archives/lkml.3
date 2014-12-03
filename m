Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaLCXuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:50:52 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33855 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaLCXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:50:51 -0500
Message-ID: <547FA1DC.6090307@kernel.dk>
Date: Wed, 03 Dec 2014 16:50:52 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] block / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
References: <1836422.FyhARLgxbM@vostro.rjw.lan>
In-Reply-To: <1836422.FyhARLgxbM@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 06:34 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
>
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in the block device core.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
>
> Please let me know if it is OK to take this one into linux-pm.

Yes that's fine, you can add my acked-by to it.

-- 
Jens Axboe

