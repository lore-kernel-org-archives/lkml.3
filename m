Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3GYGqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:46:55 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:52894 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3GYGqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:46:53 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApB+AP7I8FFV5qu1PGdsb2JhbABagwaDKCOFALYQBAMBgRcXAwEBAQE4NYIkAQEEATocIwULCAMhJQ8FJQoaiB0KuggWj2cHgxJuA5dehjOOMTo
X-IronPort-AV: E=Sophos;i="4.89,741,1367964000"; 
   d="scan'208";a="367481261"
From: rydberg@euromail.se
Date: Thu, 25 Jul 2013 08:48:47 +0200
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [63/85] Input: bcm5974 - add support for the 2013 MacBook Air
Message-ID: <20130725064847.GA3581@polaris.bitmath.org>
References: <lsq.1374674564.753305150@decadent.org.uk>
 <lsq.1374674565.258792026@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1374674565.258792026@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> 3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

Unfortunately, kernels before 3.7 are missing a patch needed for this
to work. As is, the driver will crash during urb setup because the bt
endpoint no longer exists. Therefore, please remove this patch from
the 3.2 queue.

Thanks,
Henrik
