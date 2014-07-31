Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaGaJFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:05:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:51012 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaGaJF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:05:29 -0400
Message-ID: <1406797513.4935.182.camel@pasglop>
Subject: Re: [PATCH 0/3] therm_windtunnel doesn't work properly on PowerMac
 G4
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: kreijack@inwind.it, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 31 Jul 2014 19:05:13 +1000
In-Reply-To: <20140731085211.5941bd33@endymion.delvare>
References: <53D95AAF.6030309@inwind.it> <1406770020.4935.166.camel@pasglop>
	 <20140731085211.5941bd33@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 08:52 +0200, Jean Delvare wrote:
> This leaves only two drivers still using the old binding model:
> macintosh/therm_pm72 and sound/ppc/keywest. Could any of you please
> convert these to the standard binding model so that I can finally get
> rid of i2c_driver.attach_adapter? That would be wonderful.

therm_pm72 is deprecated, I wrote windfarm_pm72 to replace it so that I
wouldn't have to convert the old one :-)

We can probably kill it now, it's been long enough.

As for the old audio one, that's the trickiest bit. I'm so completely
swamped at the moment, I really haven't had a chance, on the other hand
I'm not sure anybody will notice anymore if we just kill the bloody
thing ...

Cheers,
Ben.


