Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3EHQHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:07:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3EHQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <1367996197-32748-1-git-send-email-tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
Date: Thu, 9 May 2013 00:07:17 +0800
Message-ID: <CACVXFVPwXtD8uO-L6xhYC8j1B3XMVKQSDd=tMskgAvGQ=dNrZw@mail.gmail.com>
Subject: Re: [PATCH 0/3] firmware: Fix usermodehelper deadlock at shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Sorry for not CC list.

On Wed, May 8, 2013 at 2:56 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Hi,
>
> this is a series of patches for the issue we faced in the firmware
> loader code during debugging the problem with dell_rbu driver with
> 3.9 kernel.
>
> The original problem was that the shutdown gets stuck when DELL BIOS
> update is performed.  This turned out to be a problem in the firmware
> loader.  Although the reason of dell_rbu driver breakage is still

Sorry, from these patchset, I can't see why it is a problem in firmware.

> unclear, we should fix the firmware loader side, at least, not to
> stall during shutdown.

Firstly you need to describe what/why is the stall? In fact, firmware
loading can't stall forever and it will timeout, but the current 60sec
timeout might be too long.

Thanks,
--
Ming Lei
