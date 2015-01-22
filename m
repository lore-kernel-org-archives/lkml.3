Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbbAVV3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:29:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51757 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbbAVV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:29:07 -0500
Date: Thu, 22 Jan 2015 21:29:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Moore <pmoore@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, rgb@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
Message-ID: <20150122212902.GW29656@ZenIV.linux.org.uk>
References: <20150122045303.1347.98054.stgit@localhost>
 <20150122075429.GV29656@ZenIV.linux.org.uk>
 <4011794.crgx99Gu8a@sifl>
 <25860171.h6aocaXFeh@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25860171.h6aocaXFeh@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:25:13PM -0500, Paul Moore wrote:

> Your experimental branch looks good to me, thanks.

Pushed into for-next; I'm probably going to move that stuff into a never-rebased
branch, merged into for-next and safe to pull into your tree if you want to do
something on top of that set.
