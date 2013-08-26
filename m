Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3HZLnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:43:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab3HZLnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:43:11 -0400
Date: Mon, 26 Aug 2013 13:43:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] HID: Win 8 multitouch panels detection in core
In-Reply-To: <20130822175515.GA5215@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1308261342430.2077@pobox.suse.cz>
References: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com> <20130822175515.GA5215@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Henrik Rydberg wrote:

> > this is the v3 of this patch series.
> > 
> > Srinivas, I still did not added your tested-by as I made minors modifications of
> > the patches 1 and 2. Now only the patch 1 will impact sensor_hub, and patch 2
> > will not impact this. Maybe just wait for Henrik to put his "Reviewed-by" before
> > giving one last test.
> 
> Here goes:
> 
>     Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks guys. Not applying this just yet, waiting for Tested-by: from 
Srinivas.

-- 
Jiri Kosina
SUSE Labs
