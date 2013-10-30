Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3J3NYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:24:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3J3NYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:24:10 -0400
Date: Wed, 30 Oct 2013 14:24:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Bibek Basu <bbasu@nvidia.com>
Cc: benjamin.tissoires@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: Stop querying for init reports
In-Reply-To: <1382329753-15589-1-git-send-email-bbasu@nvidia.com>
Message-ID: <alpine.LNX.2.00.1310301423530.21144@pobox.suse.cz>
References: <1382329753-15589-1-git-send-email-bbasu@nvidia.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Oct 2013, Bibek Basu wrote:

> According to specifications, HID over I2C devices
> are not bound to respond to query for INPUT
> REPORTS. Thus dropping the call during init
> as many devices does not respond causing error
> messages during boot.
> 
> Signed-off-by: Bibek Basu <bbasu@nvidia.com>

I am queuing this for 3.13. Thanks,

-- 
Jiri Kosina
SUSE Labs
