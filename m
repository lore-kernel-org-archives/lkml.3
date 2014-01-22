Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaAVJa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:30:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaAVJaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:30:24 -0500
Date: Wed, 22 Jan 2014 10:30:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Reyad Attiyat <reyad.attiyat@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add HID's to hid-microsoft driver of Surface Type/Touch
 Cover 2 to fix bug
In-Reply-To: <CAN+gG=Fy7+ugZY2V_qgdp5FVf8YzAK-BhGGtz+HKEvCO8zcAwg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1401221028420.27143@pobox.suse.cz>
References: <CA+BWVUTkaUt8Ys_40r7zFV_wBtY7iWTTmUUL+bHj=e3NwAtgNg@mail.gmail.com> <alpine.LRH.2.00.1401210747120.12934@twin.jikos.cz> <CA+BWVUQnyZ=YP95V25BoiM9QLBaL78Hd0fC8DOrSfoH60cvD3A@mail.gmail.com>
 <CAN+gG=Fy7+ugZY2V_qgdp5FVf8YzAK-BhGGtz+HKEvCO8zcAwg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Benjamin Tissoires wrote:

> > From 291742873dcf181faf9657b41279487f31302c73 Mon Sep 17 00:00:00 2001
> > From: Reyad Attiyat <reyad.attiyat@gmail.com>
> > Date: Tue, 21 Jan 2014 01:22:25 -0600
> > Subject: [PATCH 1/1] Added in HID's for Microsoft Surface Type/Touch cover 2.
> >  This is to fix bug 64811 where this device is detected as a multitouch device
> >
> 
> You are missing a commit message here (the first message you sent
> would fit perfectly here).

Also it's missing a Signed-off-by: line and Reyad's mail client damaged 
the patch by line-wrapping.

> So to sum up, with the commit message amended:
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Reyad, please do a full resubmission with

- proper changelog
- Signed-off-by: line added
- Benjamin's Reviewed-by: line added
- your mail client fixed so that it doesn't damage the patch

I'll then queue the patch in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
