Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3FEAga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 20:36:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29921 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab3FEAg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 20:36:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="scan'208";a="348229301"
Message-ID: <1370392712.4432.27.camel@ymzhang.sh.intel.com>
Subject: Re: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Liu, Joseph" <Joseph.Liu@emulex.com>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 05 Jun 2013 08:38:32 +0800
In-Reply-To: <CAErSpo5OMuW_fg4DYAqg=xcY8USDhC89Mgt66BwoSzss41UKMQ@mail.gmail.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
	 <20130520224824.GA31740@google.com>
	 <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
	 <CAErSpo4kvEkUtYFXnoE8yDnHsUD8Z6EUrKaXaJ=yy4yMcJ0veA@mail.gmail.com>
	 <CAErSpo5OMuW_fg4DYAqg=xcY8USDhC89Mgt66BwoSzss41UKMQ@mail.gmail.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 12:04 -0600, Bjorn Helgaas wrote:
> I'm not sure where we are with this patch.  I think Joseph initially
> reported a problem (though I haven't actually seen that), and this
> patch fixed it, so it seems like there's something we want to do here.
Yes, indeed. We checked Powerpc error handling and plan to use the
similar method to deal with the issue.

Sorry for replying very late. I move to Android smartphone area and am
very busy on many top issues.


