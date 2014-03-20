Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbaCTVBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:01:42 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:60562 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758959AbaCTVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:01:41 -0400
Date: Thu, 20 Mar 2014 22:01:37 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Joe Perches <joe@perches.com>
Cc: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: add support for maxim dallas rtc ds1347
Message-ID: <20140320220137.6a7745cd@linux.lan.towertech.it>
In-Reply-To: <1395343195.7776.37.camel@joe-AO722>
References: <532B3AB9.5050809@gmail.com>
	<1395343195.7776.37.camel@joe-AO722>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 12:19:55 -0700
Joe Perches <joe@perches.com> wrote:

> This depends on how long you want to live, but it could be
> 
> 	while (dt->tm_year >= 100)

 
 dt->tm_year % 100 ?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

