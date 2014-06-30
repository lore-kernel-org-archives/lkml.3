Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaF3RO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:14:58 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:49266 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaF3RO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:14:57 -0400
Message-ID: <53B19B0E.8000702@gmail.com>
Date: Mon, 30 Jun 2014 10:14:54 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/3] MIPS: OCTEON: Minimal support for D-Link DSR-1000N
References: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 01:34 PM, Aaro Koskinen wrote:
> Hi,
>
> The following patches add minimal support for D-Link DSR-1000N router.

Which OCTEON chip does this device contain?

Also what is the bootloader version on the board?

David Daney


> USB and ethernet ports should now work with these patches.
> (I guess WLAN (PCI/ath9k) should work too; I was able to scan networks,
> but for some reason it did not connect to my AP.)
>
> Aaro Koskinen (3):
>    MIPS: OCTEON: cvmx-bootinfo: add D-Link DSR-1000N
>    MIPS: OCTEON: add USB clock type for D-Link DSR-1000N
>    MIPS: OCTEON: add interface & port definitions for D-Link DSR-1000N
>
>   .../cavium-octeon/executive/cvmx-helper-board.c    | 22 ++++++++++++++++++++++
>   arch/mips/include/asm/octeon/cvmx-bootinfo.h       |  2 ++
>   2 files changed, 24 insertions(+)
>

