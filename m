Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaKTDEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 22:04:40 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40828 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaKTDEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 22:04:38 -0500
Date: Wed, 19 Nov 2014 19:04:34 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: ralf@linux-mips.org, f.fainelli@gmail.com, jfraser@broadcom.com,
        dtor@chromium.org, tglx@linutronix.de, jason@lakedaemon.net,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 00/22] Multiplatform BMIPS kernel
Message-ID: <20141120030434.GE24364@ld-irv-0074>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 04:17:24PM -0800, Kevin Cernekee wrote:
> The lack of a reboot handler is annoying; syscon-reboot probably won't work
> on STB (because it requires two writes).

Can't you reuse drivers/power/reset/brcmstb-reboot.c ?

Brian
