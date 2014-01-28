Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaA1Tu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:50:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbaA1Tu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:50:28 -0500
Date: Tue, 28 Jan 2014 20:50:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: add FocalTech FTxxxx support
In-Reply-To: <1390512794-3825-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1401282049470.22492@pobox.suse.cz>
References: <1390512794-3825-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Benjamin Tissoires wrote:

> This is a Win7 device which does not work correctly with the default
> settings (not the previous default BT).
> However, the quirk ALWAYS_TRUE makes it working like a charm.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> well, it's been a long time since I did not add those kind of small patches.
> And I really hope not having to do some gain soon :)

World is a crude place :)

Applied, thanks Benjamin.

-- 
Jiri Kosina
SUSE Labs
