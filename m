Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaBQNTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:19:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbaBQNTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:19:40 -0500
Date: Mon, 17 Feb 2014 14:19:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] HID: spring cleanup v2
In-Reply-To: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1402171419180.1192@pobox.suse.cz>
References: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Benjamin Tissoires wrote:

> Hi guys,
> 
> well, here comes the promised v2 of the ll_transport cleanup.
> 
> As I said, I removed patches which need some more work, and kept only the
> trivial ones. I also added David's documentation, which gives us a net
> difference of +210 lines of code :(
> Let's say that we still have a net worth of -106 lines of actual code :)
> 
> Cheers,
> Benjamin
> 
> Changes since v1:
> - removed uhid, i2c-hid patches
> - removed the previous 11/11 (move hid_output_raw_report to hid_ll_driver)
> - hid-logitech-dj: use hid_hw_raw_request instead of hid_output_report (2/9)
> - add documentation - I removed the hid_input_event() doc (9/9)

Good job, thanks! Now applied.

-- 
Jiri Kosina
SUSE Labs
