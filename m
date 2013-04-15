Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3DOPLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:11:46 -0400
Received: from ra.se.axis.com ([195.60.68.13]:58515 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab3DOPLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:11:45 -0400
Date: Mon, 15 Apr 2013 17:09:18 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CRIS: remove "config OOM_REBOOT"
Message-ID: <20130415150918.GH11974@axis.com>
References: <1363988751.1390.199.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363988751.1390.199.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 10:45:51PM +0100, Paul Bolle wrote:
> The Kconfig symbol OOM_REBOOT got added in v2.6.25. It has never been
> used. Its entry can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Agreed, applied to the for-next branch of the CRIS-tree.
Sorry for the slow response.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
