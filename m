Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaCNOjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:39:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaCNOjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:39:33 -0400
Date: Fri, 14 Mar 2014 15:39:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] HID: ll transport cleanup: final round
In-Reply-To: <1394337163-32478-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1403141539120.3690@pobox.suse.cz>
References: <1394337163-32478-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2014, Benjamin Tissoires wrote:

> Hop, a new version.
> 
> As mentioned in the v2, I did not changed 2/4 but I'll add a patch later
> to remove buf[0] from the call. But I need to do tests first.
> 
> Thanks for all the work to everybody who took a part in this cleanup.

Awesome, thanks.

Now queued in for-3.15/hid-core-ll-transport-cleanup.

-- 
Jiri Kosina
SUSE Labs
