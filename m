Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaLSKxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:53:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaLSKxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:53:42 -0500
Date: Fri, 19 Dec 2014 11:53:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: logitech-hidpp: prefix the name with Logitech
In-Reply-To: <20141217152837.GA16047@mail.corp.redhat.com>
Message-ID: <alpine.LNX.2.00.1412191153150.1680@pobox.suse.cz>
References: <1418337599-10239-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1412171037200.1680@pobox.suse.cz> <20141217152837.GA16047@mail.corp.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Benjamin Tissoires wrote:

> Thanks for applying most of the patches (2 are missing, I'll raise them
> in your inbox :-P )
> 
> Regarding this one, I was wondering if we could not force it into 3.19,
> or at least add a stable@ tag. I had requested this in the first
> submission, and the rationale was to not change a third time the name of
> the device (from "Logitech Unifying Device. Wireless PID:XXXX" to
> "[TMK]XXX" to "Logitech [TMK]XXX").
> 
> Userspace would be grateful to have a reliable name.

Fair enough. I've cherry-picked it from for-3.20/logitech into 
for-3.19/upstream-fixes as well.

Thanks,

-- 
Jiri Kosina
SUSE Labs
