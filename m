Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaLQIJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:09:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaLQIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:09:44 -0500
Date: Wed, 17 Dec 2014 09:09:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: bail out if wtp_connect fails
In-Reply-To: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1412170908351.1680@pobox.suse.cz>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Benjamin Tissoires wrote:

> If wtp_connect() fails, that means most of the time that the device has
> been disconnected. Subsequent attempts to contact the device will fail
> too, so it's simpler to bail out earlier.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I have applied this one to for-3.20/logitech. I am postponing 2/2, 
expecting v2 with an updated comment.

Thanks,

-- 
Jiri Kosina
SUSE Labs
