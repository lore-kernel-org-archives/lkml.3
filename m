Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaEOQ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:56:41 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:35293 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbaEOQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:56:39 -0400
Date: Thu, 15 May 2014 18:56:35 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: query regarding not returning error if request_irq fails after
 rtc registration
Message-ID: <20140515185635.617d372b@linux.lan.towertech.it>
In-Reply-To: <5374EF1A.2000609@gmail.com>
References: <5374EF1A.2000609@gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 22:15:14 +0530
RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com> wrote:

> my question is that the set_alarm and alarm_irq_enable is still active,
> so should i use some flag in the global private variable of the driver
> so that if the request irq fails, then using this flag the set_alarm
> and alarm_irq_enable can return error since there is no irq handler
> for the rtc interrupt 
> or is there any other solution 
> or let the set_alarm and alarm_irq_enable routine be as it is and will

 you can use a flag (or set the irq to -1)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

