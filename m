Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaG2JPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:15:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbaG2JO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:14:59 -0400
Date: Tue, 29 Jul 2014 11:14:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: microcai@fedoraproject.org
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        microcai <microcaicai@gmail.com>
Subject: Re: [PATCH] add quirks for 0x04d9:0xa096 hid keyborad device
In-Reply-To: <1405300412-31346-1-git-send-email-microcai@fedoraproject.org>
Message-ID: <alpine.LNX.2.00.1407291114470.16390@pobox.suse.cz>
References: <1405300412-31346-1-git-send-email-microcai@fedoraproject.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, microcai@fedoraproject.org wrote:

> I am using a USB keyborad that give me
> "usb_submit_urb(ctrl) failed: -1" error when I plugin it.
> and I need to wait for 10s for this device to be ready.
> 
> by adding this quirks, the usb keyborad is usable right after plugin
> 
> Signed-off-by: Wangzhao Cai <microcaicai@gmail.com>

Applied.

-- 
Jiri Kosina
SUSE Labs
