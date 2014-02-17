Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaBQNUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:20:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaBQNUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:20:51 -0500
Date: Mon, 17 Feb 2014 14:20:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 7/9] HID: remove hid_get_raw_report in struct
 hid_device
In-Reply-To: <CAN+gG=E__6ejV_BqdtM8iwyM-UCdB1G49nvEZn3WTeELixqs4Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1402171420160.1192@pobox.suse.cz>
References: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com> <1391636004-29354-8-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1402171414490.1192@pobox.suse.cz>
 <CAN+gG=E__6ejV_BqdtM8iwyM-UCdB1G49nvEZn3WTeELixqs4Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Benjamin Tissoires wrote:

> >> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
> >> index f5a2b19..12439e1 100644
> >> --- a/drivers/hid/uhid.c
> >> +++ b/drivers/hid/uhid.c
> >> @@ -404,7 +404,6 @@ static int uhid_dev_create(struct uhid_device *uhid,
> >>       hid->uniq[63] = 0;
> >>
> >>       hid->ll_driver = &uhid_hid_driver;
> >> -     hid->hid_get_raw_report = uhid_hid_get_raw;
> >
> > I'll queue a followup patch on top of this that completely removes
> > uhid_hid_get_raw(), as it's unused now.
> 
> Jiri, please don't. It was a mistake which was fixed in the next patch
> series (2/14: HID: uHID: implement .raw_request). It was already
> reviewed by David, so you can apply it right now.

Yeah, I just came to the same conclusion during review as we speak. I will 
sort it out.

Thanks.

-- 
Jiri Kosina
SUSE Labs
