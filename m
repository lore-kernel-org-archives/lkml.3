Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3HVRuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:50:07 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:58162 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3HVRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:50:04 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqRUAEJOFlJV5qu1PGdsb2JhbABagweDOCIBhQC4M4EcFwMBAQEBODWCJAEBBAE6HBMBDwULCAMhJQ8FJQoaEx6HbAq2eBaQUAeDG3sDl2WGPY4/Og
X-IronPort-AV: E=Sophos;i="4.89,935,1367964000"; 
   d="scan'208";a="602341893"
Date: Thu, 22 Aug 2013 19:55:15 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] HID: Win 8 multitouch panels detection in core
Message-ID: <20130822175515.GA5215@polaris.bitmath.org>
References: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

thanks for the patches, it all looks fine now.

> this is the v3 of this patch series.
> 
> Srinivas, I still did not added your tested-by as I made minors modifications of
> the patches 1 and 2. Now only the patch 1 will impact sensor_hub, and patch 2
> will not impact this. Maybe just wait for Henrik to put his "Reviewed-by" before
> giving one last test.

Here goes:

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Cheers,
Henrik
