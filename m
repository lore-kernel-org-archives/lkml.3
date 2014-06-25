Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaFYBKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:10:10 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:38570 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaFYBKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:10:08 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: tiwai@suse.de, leedom@chelsio.com, cocci@systeme.lip6.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [RESEND][PATCH 3/3] p54: use request_firmware_direct() for optional EEPROM override
Date: Wed, 25 Jun 2014 03:10:02 +0200
Message-ID: <1582751.494RL7XPxB@blech>
User-Agent: KMail/4.12.4 (Linux/3.16.0-rc1-wl+; KDE/4.13.1; x86_64; ; )
In-Reply-To: <1403649583-12707-4-git-send-email-mcgrof@do-not-panic.com>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com> <1403649583-12707-4-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 24, 2014 03:39:43 PM Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> The p54 driver uses request_firmware() twice, once for actual
> firmware and then another time for an optional user overide on
> EEPROM, 3826.eeprom. The custom EEPROM  is optional but if not
> present we'll introduce an extra lag of 60 seconds with udev
> present. Annotate we don't want udev nonsense here to avoid
> the lag in case its not present.
> [...]
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: cocci@systeme.lip6.fr
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Acked-By: Christian Lamparter <chunkeey@googlemail.com>

