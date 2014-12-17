Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaLQP3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:29:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQP3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:29:01 -0500
Date: Wed, 17 Dec 2014 10:28:37 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: logitech-hidpp: prefix the name with Logitech
Message-ID: <20141217152837.GA16047@mail.corp.redhat.com>
References: <1418337599-10239-1-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1412171037200.1680@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412171037200.1680@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17 2014 or thereabouts, Jiri Kosina wrote:
> On Thu, 11 Dec 2014, Benjamin Tissoires wrote:
> 
> > Current names are reported as "K750", "M705", and it can be misleading
> > for the users when they look at their input device list.
> > 
> > Prefixing the names with "Logitech " makes things better.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> > 
> > Changes in v2:
> > - renamed PREFIX_SIZE into PREFIX_LENGTH
> > - changed "name_length + PREFIX_LENGTH;" into "PREFIX_LENGTH + name_length;"
> > - rebased on Peter's last patch series
> 
> Ok, looks reasonable. I was waiting whether someone from Logitech would 
> comment on the prefix check that could be used other than "Logitech".
> 
> But we can add that later.
> 
> Applied to for-3.20/logitech, thanks.
> 

Hi Jiri,

Thanks for applying most of the patches (2 are missing, I'll raise them
in your inbox :-P )

Regarding this one, I was wondering if we could not force it into 3.19,
or at least add a stable@ tag. I had requested this in the first
submission, and the rationale was to not change a third time the name of
the device (from "Logitech Unifying Device. Wireless PID:XXXX" to
"[TMK]XXX" to "Logitech [TMK]XXX").

Userspace would be grateful to have a reliable name.

Cheers,
Benjamin
