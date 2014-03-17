Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbaCQO2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:28:33 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:27632 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932700AbaCQO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:28:31 -0400
X-Greylist: delayed 1604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 10:28:31 EDT
Date: Mon, 17 Mar 2014 15:00:56 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Message-ID: <20140317140056.GX21643@enneenne.com>
Mail-Followup-To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Gregory Clement <gregory.clement@free-electrons.com>
References: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395064628-644-16-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395064628-644-16-git-send-email-alexandre.belloni@free-electrons.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.10
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH v2 15/15] ARM: at91/dt: at91-cosino_mega2560 remove
 useless tsadcc node
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on goldrake.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 02:57:08PM +0100, Alexandre Belloni wrote:
> The tsadcc node is useless as it doesn't refer to anything and the touchscreen
> is handled by the adc0 node.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Rodolfo Giometti <giometti@linux.it>

Acked.

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
