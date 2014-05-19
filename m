Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaESQTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:19:24 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:56539 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbaESQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:19:18 -0400
Date: Mon, 19 May 2014 18:19:14 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: ravi23ganiga@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [rtc-linux] [PATCH] rtc: fix potential race condition and
 remove build errors
Message-ID: <20140519181914.60f8f3b7@linux.lan.towertech.it>
In-Reply-To: <1400515100-9185-1-git-send-email-ravi23ganiga@gmail.com>
References: <1400515100-9185-1-git-send-email-ravi23ganiga@gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 21:28:20 +0530
Raghavendra Ganiga <ravi23ganiga@gmail.com> wrote:

> also the sysfs will not create entry for alarm if
> irq registration fails in probe
> 
> Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

