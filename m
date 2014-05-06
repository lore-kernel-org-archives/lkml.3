Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769AbaEFJ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:57:21 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:55520 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934608AbaEFJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:57:20 -0400
Date: Tue, 6 May 2014 11:57:18 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: rtc: add support for maxim dallas rtc ds1343 and ds1344
Message-ID: <20140506115718.03a9bbc3@linux.lan.towertech.it>
In-Reply-To: <5367D566.7000601@gmail.com>
References: <5367D566.7000601@gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2014 23:46:06 +0530
RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com> wrote:

> 1. glitch filter read and write parameter
> 2. alarm status read parameter
> 3. alarm mode read parameter
> 4. trickle charger read parameter
> 
> and i am removing the proc interface. 
> 
> is the above implementation ok as per your last comment
> on the proc interface. please provide the feedback.

 That's sounds like a plan. Please send the code when you're ready.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

