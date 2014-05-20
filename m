Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaETPbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:31:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbaETPbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:31:11 -0400
Date: Tue, 20 May 2014 17:31:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jamie Lentin <jm@lentin.co.uk>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Add custom driver for Lenovo ThinkPad Compact
 Bluetooth Keyboard
In-Reply-To: <alpine.DEB.2.02.1405201555110.4059@marmot.wormnet.eu>
Message-ID: <alpine.LNX.2.00.1405201726040.1615@pobox.suse.cz>
References: <1395786407-11273-1-git-send-email-jm@lentin.co.uk> <alpine.LNX.2.00.1405201644230.1615@pobox.suse.cz> <alpine.DEB.2.02.1405201555110.4059@marmot.wormnet.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Jamie Lentin wrote:

> > I think it'd make more sense if this could be folded into 
> > hid-lenovo-tpkbd driver. Could you please do that and resubmit?
> 
> I can do if required, although I didn't originally since there would be no
> common code whatsoever between the keyboards. 

That's not a problem really. I am trying to have the functionality mostly 
grouped together by vendor, and not pollute the tree by gazillion of tiny 
single-function driver.

> I have both the USB and the Bluetooth versions of this keyboard now, once I
> have finished support for both[0] I will resubmit support for both.

Thanks,

-- 
Jiri Kosina
SUSE Labs
