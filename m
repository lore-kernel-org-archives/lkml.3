Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3ALVOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:14:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3ALVOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:14:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 0/3] Use helper clockevents_config_and_register()
Date: Sat, 12 Jan 2013 21:14:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>, arm@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301122114.07278.arnd@arndb.de>
X-Provags-ID: V02:K0:ZjfVckQ9ab0sy+0P2J3R/nZgRDpPJw/nOM8//hqBFAe
 529/CQxAiWcMojsAfuTkKErfxaSy5rWwsKCI3sBoIrYhQvBYId
 5dtT56WZiVFtSF6xUSEmzk4hpTs7rEbcL4U+odKbOXOGsIFIJi
 RgbIxzow/CamOLZO298B0qFjwPLGaF0wdg/ek8dwZ5D4vMynj4
 GTicVQScXOAtTY66cBYp16GWomLAMtRLvB89CM4fES/j96FOUC
 Kh910lkaLDE5QRS4XuE+ECncj2zb0VWY8ucBgGHeEnCDgvMcI5
 mcYvzAK46KNhUYdmS9GOqEKQYl+f7xt+nNKoiRsRa7287y4YD4
 6Gmc4BPbbmFUgRT1NoLo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2013, Shawn Guo wrote:
> The clockevent core is able to figure out the best mult and shift,
> calculate min_delta_ns and max_delta_ns, with the necessary info passed
> into clockevents_config_and_register().  Use this handy helper to make
> the drivers less error prone and save some LOC.
> 
> Changes since v1:
>  - Add one patch to export clockevents_config_and_register for fixing
>    the error [1] reported by Fengguang.
>  - Add Acked-by and Tested-by tags given by people (Thanks!)
> 
> [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/209152

Very nice series!

Acked-by: Arnd Bergmann <arnd@arndb.de>
