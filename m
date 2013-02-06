Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3BFNLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:11:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3BFNLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:11:13 -0500
Date: Wed, 6 Feb 2013 14:11:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Support of Nexio 42" and new default class for
 hid-multitouch
In-Reply-To: <CAN+gG=F5KHmq2F_op6RbvXiSp=T0oD_cTgPuBHptXVHyHZwpjA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1302061410230.16860@pobox.suse.cz>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com> <20130203130731.GA2677@polaris.bitmath.org> <CAN+gG=GRS+fx4c3Kdba-89+ba8soimMm_rv7HDuaZLZWseQGuQ@mail.gmail.com> <20130204115443.GA4405@polaris.bitmath.org>
 <alpine.LNX.2.00.1302051212550.2260@pobox.suse.cz> <CAN+gG=F5KHmq2F_op6RbvXiSp=T0oD_cTgPuBHptXVHyHZwpjA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Benjamin Tissoires wrote:

> > Also, Benjamin, perhaps it'd make sense to put a link somewhere into
> > in-tree documentation, with pointer to your testing suite?
> 
> Good idea. However, I prefer removing the dependencies between hid
> drivers and usbhid before including such reference to avoid testers
> getting kernel oops while trying to access the usb layer from the uhid
> device... So, yesterday and this morning, I rebased/updated Henrik's
> patches on this topic. They should be ready soon.

Makes sense, thanks.

> Do you mind if I send the usbhid dependency and the pen+multitouch 
> series this week, or we are too close to the 3.9 opening window?

Please just send the patches, and let's see whether they will make it for 
3.8 or I'll queue (some of) them for 3.9.

Thanks,

-- 
Jiri Kosina
SUSE Labs
