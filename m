Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaLED2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:28:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbaLED2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:28:04 -0500
Date: Wed, 3 Dec 2014 05:34:32 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: mjg59@srcf.ucam.org, pavel@ucw.cz, pali.rohar@gmail.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141203133431.GG75099@vmdeb7>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:16:20AM +0100, Gabriele Mazzotta wrote:
> Currently dell-wmi reports keypresses for WMI events that are
> notifications of changes performed by the BIOS.
> This patch series make sure that no keypresses are sent for those
> events so that nothing is done from userspace. 
> 
> Gabriele Mazzotta (3):
>   dell-wmi: Use appropriate keycode for radio state changes
>   dell-wmi: Don't report keypresses for radio state changes

Merged into one patch, queued.

>   dell-wmi: Don't report keypresses on keybord illumination change

Queued.

Thanks Gabriele.

-- 
Darren Hart
Intel Open Source Technology Center
