Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3DDHrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:47:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933318Ab3DDHrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:47:31 -0400
Date: Thu, 4 Apr 2013 09:47:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>
Cc: benjamin.tissoires@gmail.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-hid: fix length for set/get report in i2c hid
In-Reply-To: <1364993121-18800-1-git-send-email-huzefa.nomanx.kankroliwala@intel.com>
Message-ID: <alpine.LNX.2.00.1304040946170.30938@pobox.suse.cz>
References: <1364993121-18800-1-git-send-email-huzefa.nomanx.kankroliwala@intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013, Huzefa Kankroliwala wrote:

> With the current i2c hid driver set/get report does not work
> as expected, for e.g sensor hub properties like power state,
> frequency etc is not set properly on the device as a result
> we do not get events.
> The problem is that i2c hid driver in function i2c_hid_request
> sets length equal to default buffer size for which the sensor
> hub does not respond on get/set commands. Use report length
> and calculate it based on report size and id.
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>

This is based on some old version of the driver though. Could you please 
rebase it so that it applies on top of for-next branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git

and resend? (actually rebasing on Linus' current tree would be absolutely 
sufficient).

Thanks.

-- 
Jiri Kosina
SUSE Labs
