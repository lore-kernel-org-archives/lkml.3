Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbASSDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:03:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40229 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbASSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:03:15 -0500
Date: Mon, 19 Jan 2015 21:03:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v2 1/3] Drivers: hv: check vmbus_device_create() return
 value in vmbus_process_offer()
Message-ID: <20150119180301.GF6456@mwanda>
References: <1421686573-12771-1-git-send-email-vkuznets@redhat.com>
 <1421686573-12771-2-git-send-email-vkuznets@redhat.com>
 <20150119175857.GE6456@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119175857.GE6456@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 08:58:58PM +0300, Dan Carpenter wrote:
> "error" is a crap label name because it doesn't tell you what the code
> does.  A better name is "err_free_chan" or something which talks about
> freeing the channel.

If you choose your label names correctly, then most of the time you can
just read the code from top to bottom and understand it without skipping
back and forth.

regards,
dan carpenter

