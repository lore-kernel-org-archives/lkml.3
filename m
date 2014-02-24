Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaBXKm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:42:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26972 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:42:25 -0500
Date: Mon, 24 Feb 2014 13:42:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        haiyangz@microsoft.com
Subject: Re: [PATCH v2 2/5] vmbus: add missing breaks
Message-ID: <20140224104207.GG26722@mwanda>
References: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
 <1393237516-28545-3-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393237516-28545-3-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry, I know it sucks to not get credit for fixes, but please just
fold this into [patch 1/5].  We really should have a tag for this kind
of thing.

Would something like this work?
Additional-Fixes: Gerd Hoffmann <kraxel@redhat.com>

regards,
dan carpenter


