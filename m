Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaLSKpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:45:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaLSKpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:45:53 -0500
Date: Fri, 19 Dec 2014 11:45:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Wu <peter@lekensteyn.nl>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: avoid unintended fall-through
In-Reply-To: <1418691016-30681-4-git-send-email-peter@lekensteyn.nl>
Message-ID: <alpine.LNX.2.00.1412191145400.1680@pobox.suse.cz>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl> <1418691016-30681-4-git-send-email-peter@lekensteyn.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Peter Wu wrote:

> Add a return to avoid a fall-through. Introduced in commit
> 57ac86cf52e903d9e3e0f12b34c814cce6b65550 ("HID: logitech-hidpp: add
> support of the first Logitech Wireless Touchpad").
> 
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>

Applied to for-3.19/upstream-fixes.

Thanks,

-- 
Jiri Kosina
SUSE Labs
