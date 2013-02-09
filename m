Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947487Ab3BIAXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:23:02 -0500
Received: from science.horizon.com ([71.41.210.146]:21082 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758652Ab3BIAXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:23:00 -0500
Date: 8 Feb 2013 19:22:58 -0500
Message-ID: <20130209002258.15821.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gregkh@linuxfoundation.org, linux@horizon.com
Subject: Re: [PATCH 0/7] 3.8-rc regression with pps-ldisc due to 70ece7a731
Cc: giometti@linux.it, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, peter@hurleysoftware.com
In-Reply-To: <20130208233656.GA7700@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As this is a breakage in 3.8-rc1, is there any way to pull out patches 5
> and 6 in a format that I can apply them now, or in a way that I can get
> I can't apply all of these to 3.8-final now, as it's way too late.

I'll reorder them for you.  But Philipp will be bitterly disappointed. :-)

The other cleanups are far smaller and lower risk than the infrastructure
added in #5; I was just being OCD about committing the "least patchable
unit".
