Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3L0R3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:29:46 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:54992 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab3L0R3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:29:45 -0500
Date: Fri, 27 Dec 2013 18:29:42 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: question about drivers/rtc/rtc-cmos.c
Message-ID: <20131227182942.66e7b109@linux.lan.towertech.it>
In-Reply-To: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6>
References: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Dec 2013 20:32:12 +0100 (CET)
Julia Lawall <julia.lawall@lip6.fr> wrote:


> Is it intentional that the error code returned by 
> hpet_register_irq_handler is put ina local variable that will not be seen 
> at label cleanup1?  The return value is retval, which is 0 at this point.

  Well, I'd say it's an error. Did you got it by hand
  or with one of your tools? ;)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

