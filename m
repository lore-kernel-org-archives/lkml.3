Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaBZOpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:45:06 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35746 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBZOpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:45:02 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH 1/5] ARM: davinci: remove tnetv107x support
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
	<1393418614-3968549-2-git-send-email-arnd@arndb.de>
Date: Wed, 26 Feb 2014 06:44:58 -0800
In-Reply-To: <1393418614-3968549-2-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Wed, 26 Feb 2014 13:43:30 +0100")
Message-ID: <7hk3ciylud.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> The tnetv107x support does not compile, and seems to have been broken
> for a while with nobody caring to fix it. So far everyone I asked
> said it's probably dead and completely unused and will never again
> be needed in a future kernel release, so let's delete it.
>
> If someone finds a use for this code later and is able to get it
> to work again, we can always revert the removal.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Kevin Hilman <khilman@linaro.org>
