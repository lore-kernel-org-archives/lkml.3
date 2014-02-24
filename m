Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaBXQYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:24:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaBXQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:24:48 -0500
Date: Mon, 24 Feb 2014 17:24:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: benjamin.tissoires@gmail.com, dh.herrmann@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] HID: low level transport cleanup, series 3
In-Reply-To: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1402241724270.1192@pobox.suse.cz>
References: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Benjamin Tissoires wrote:

> Hi guys,
> 
> this is a new round in the low level HID transport cleanup.
> These are the formely 7/14 an 12/14 only.
> I add in between a patch which makes .raw_request mandatory, to cleanup
> the old 12/14 (so 3/3 here).
> 
> There is only two patches 2 merge after these 3... We are approaching the end!

Good stuff, thanks Benjamin. Queued for 3.15.

-- 
Jiri Kosina
SUSE Labs
