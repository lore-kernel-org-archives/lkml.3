Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaEaICA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 04:02:00 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:46808 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbaEaIB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 04:01:58 -0400
Message-ID: <1401523299.15490.6.camel@localhost.localdomain>
Subject: Re: [PATCH] driver core/platform: remove unused implicit padding in
 platform_object
From: Yann Droneaud <ydroneaud@opteya.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Sat, 31 May 2014 10:01:39 +0200
In-Reply-To: <20140530201054.GF17724@mwanda>
References: <1401480167-15091-1-git-send-email-ydroneaud@opteya.com>
	 <20140530201054.GF17724@mwanda>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Le vendredi 30 mai 2014 à 23:10 +0300, Dan Carpenter a écrit :
> This changelog doesn't match the patch.
> 

Hum, let me guess .... I've failed to set the proper subject prefix
to add v6 suffic to PATCH: 
I've changed the patch title since v5 (from Emil Goode)... so it's like
a new one.

Is it really necessary to resend the patch ?

Regards.

-- 
Yann Droneaud
OPTEYA


