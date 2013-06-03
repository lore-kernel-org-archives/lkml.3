Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3FCMct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:32:49 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:10137 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757257Ab3FCMcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:32:43 -0400
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 08:32:43 EDT
Date: Mon, 3 Jun 2013 14:04:45 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Jan Luebbe <jlu@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130603120445.GF4393@enneenne.com>
Mail-Followup-To: Jan Luebbe <jlu@pengutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1588516.WvWWFWzAui@wuerfel>
 <1370083449-11986-1-git-send-email-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370083449-11986-1-git-send-email-jlu@pengutronix.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.10
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH v2] pps-gpio: add device-tree binding and support
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on goldrake.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 12:44:09PM +0200, Jan Luebbe wrote:
> Instead of allocating a struct pps_gpio_platform_data in the DT case, store
> the necessary information in struct pps_gpio_device_data itself. This avoids
> an additional allocation and the ifdef. It also gets rid of some indirection.
> 
> Also use dev_err instead of pr_err in the changed code.
> 
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>

Acked-by: Rodolfo Giometti <giometti@enneenne.com>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
