Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3AOIzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:55:17 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:42392 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab3AOIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:55:15 -0500
Date: Tue, 15 Jan 2013 09:55:11 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, rtc-linux@googlegroups.com
Subject: Re: rtc: vt8500: Fix year field in vt8500_rtc_set_time
Message-ID: <20130115095511.1ce8e283@linux.lan.towertech.it>
In-Reply-To: <1358234563.6868.13.camel@gitbox>
References: <1358234563.6868.13.camel@gitbox>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 20:22:43 +1300
Tony Prisk <linux@prisktech.co.nz> wrote:

> Alessandro,
> 
> This patch was sent out at the same time as two other RTC fixes for
> vt8500 but this one seems to have stopped somewhere along the way while
> the other two have been accepted.

 Hi, Andrew usually picks up the patches directly from the rtc mailing list,
 unless there's an arch specific tree to carry it. 

 This one seems fine so I'm sure it's just an overlook

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

