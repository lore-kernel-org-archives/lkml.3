Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaILU6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:58:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaILU6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:58:17 -0400
Date: Fri, 12 Sep 2014 22:58:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH v2] HID: rmi: check sanity of the incoming report
In-Reply-To: <1410397358-15308-1-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1409122257500.5523@pobox.suse.cz>
References: <1410397358-15308-1-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Andrew Duggan wrote:

> From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> In the Dell XPS 13 9333, it appears that sometimes the bus get confused
> and corrupts the incoming data. It fills the input report with the
> sentinel value "ff". Synaptics told us that such behavior does not comes
> from the touchpad itself, so we filter out such reports here.
> 
> Unfortunately, we can not simply discard the incoming data because they
> may contain useful information. Most of the time, the misbehavior is
> quite near the end of the report, so we can still use the valid part of
> it.
> 
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=1123584
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
