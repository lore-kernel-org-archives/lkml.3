Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaCDOVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:21:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbaCDOVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:21:04 -0500
Date: Tue, 4 Mar 2014 15:21:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] HID: cp2112: remove the last hid_output_raw_report()
 call
In-Reply-To: <20140304141838.GD24154@mail.corp.redhat.com>
Message-ID: <alpine.LNX.2.00.1403041520480.30402@pobox.suse.cz>
References: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com> <1393633237-26496-3-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1403041445080.30402@pobox.suse.cz> <20140304141838.GD24154@mail.corp.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Benjamin Tissoires wrote:

> I need to send a v2 of hid-sony in any cases, so I guess you should not
> pull these 4 patches right away. If you prefer having this in linux-next,
> the sooner, I can also send the v2 right away, and we will fix this
> cp2112 driver next week.

That's fine, I'll wait for the whole v2 respin. Thanks,

-- 
Jiri Kosina
SUSE Labs
