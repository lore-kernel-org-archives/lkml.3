Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3GYGsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:48:55 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:53030 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3GYGsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:48:52 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoFSAPjJ8FFV5qu1PGdsb2JhbABagwaDKCOFALYYgRcXAwEBAQE4NYIkAQEEATocIwULCAMhJQ8FJQoaiB0KugkWj2cHgxJuA4xAix6GM2eNSjo
X-IronPort-AV: E=Sophos;i="4.89,741,1367964000"; 
   d="scan'208";a="586023194"
From: rydberg@euromail.se
Date: Thu, 25 Jul 2013 08:50:48 +0200
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [62/85] HID: apple: Add support for the 2013 Macbook Air
Message-ID: <20130725065048.GA3586@polaris.bitmath.org>
References: <lsq.1374674564.753305150@decadent.org.uk>
 <lsq.1374674565.974236672@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1374674565.974236672@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> 3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

Because the bcm5974 patch is unsuitable for pre-3.7 kernels, this one
is unsuitable as well; it renders the trackpad unusable. Without this
patch, we at least have one-finger mouse emulation, so, please remove
from the queue.

Thanks,
Henrik
