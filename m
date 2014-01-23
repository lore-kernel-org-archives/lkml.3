Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaAWC2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:28:30 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34620 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaAWC23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:28:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACUGKYPakuAGOWb+RetqNhEBvRP-+Pmtu2_4a2zuV0bFR0QJRA@mail.gmail.com>
References: <CACUGKYPXficVuqDgy6_Tnh9b-VOXDNK=+nqb6U5O6NpcZOGGpQ@mail.gmail.com>
	<20140122164100.GE15937@n2100.arm.linux.org.uk>
	<CACUGKYPakuAGOWb+RetqNhEBvRP-+Pmtu2_4a2zuV0bFR0QJRA@mail.gmail.com>
Date: Thu, 23 Jan 2014 00:28:28 -0200
Message-ID: <CAOMZO5BhZspH3FfDh+3z0xBpgxWEHK1Fa5KOYsN5og2VfGktXQ@mail.gmail.com>
Subject: Re: Internal error: Oops: 17 [#1] ARM
From: Fabio Estevam <festevam@gmail.com>
To: John Tobias <john.tobias.ph@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dong Aisheng <b29396@freescale.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 9:49 PM, John Tobias <john.tobias.ph@gmail.com> wrote:
> Hello all,
>
> Just to confirm that the error I posted previously exist in 3.13
> released. Just be noted that some patches related to eMMC/sdhci has
> been applied in order to boot the 3.13 on my board.
> Addition to that, I was getting additional errors (please see below):
> - It happened during the reboot.
>
> Cc'ng Dong Aisheng.

What are the steps to reproduce this? Which SoC are you using?

Regards,

Fabio Estevam
