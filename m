Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaETVUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:20:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaETVUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:20:33 -0400
Date: Tue, 20 May 2014 23:20:29 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Himangi Saraogi <himangi774@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2] hwmon: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140520232029.2631e56b@endymion.delvare>
In-Reply-To: <20140520200336.GA11723@roeck-us.net>
References: <20140520181536.GA11483@himangi-Dell>
	<20140520200336.GA11723@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 13:03:36 -0700, Guenter Roeck wrote:
> On Tue, May 20, 2014 at 11:45:37PM +0530, Himangi Saraogi wrote:
> Applied to -next, just for the sake of it, but frankly that driver
> is screwed up so badly that it is pretty much unusable anyway.
> Almost all of its attributes are non-standard, and for most of them
> that is completely unnecsssary.
> 
> Maybe we should create a to-be-removed list and put it there
> as first candidate.

The traditional way for this is to move the driver to drivers/staging,
mention a deadline in the commit message, and delete it after a few
releases if nobody steps up.

An alternative would be to contact the maintainer (or short of that,
the original contributor) of the driver for an update. Again, with a
deadline.

-- 
Jean Delvare
SUSE L3 Support
