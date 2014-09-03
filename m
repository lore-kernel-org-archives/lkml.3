Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaICVoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:44:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaICVoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:44:16 -0400
Date: Wed, 3 Sep 2014 23:44:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Add support for the Cintiq Companion
In-Reply-To: <1409773405-18030-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1409032343380.12309@pobox.suse.cz>
References: <1409773405-18030-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2014, Benjamin Tissoires wrote:

> The Wacom Cintiq Companion shares the same sensor than the Cintiq
> Companion Hybrid, with the exception of the different PIDs.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi,
> 
> I guess this could now go through Jiri's tree given that it applies on top of a
> plain 3.17-rcX. It can be scheduled for either 3.17 or 3.18 (no preferences on
> my side).

I have now queued it in hid.git#for-3.18/wacom. Thanks,

-- 
Jiri Kosina
SUSE Labs
