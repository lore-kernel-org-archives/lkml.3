Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3FENam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:30:42 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56427 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3FENak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <1370392712.4432.27.camel@ymzhang.sh.intel.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <20130520224824.GA31740@google.com> <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
 <CAErSpo4kvEkUtYFXnoE8yDnHsUD8Z6EUrKaXaJ=yy4yMcJ0veA@mail.gmail.com>
 <CAErSpo5OMuW_fg4DYAqg=xcY8USDhC89Mgt66BwoSzss41UKMQ@mail.gmail.com> <1370392712.4432.27.camel@ymzhang.sh.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Jun 2013 07:30:19 -0600
Message-ID: <CAErSpo743raREgO4zJL0pONZyOTDBy7qLX9UZzCyRsLjBD31gQ@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Cc: "Liu, Joseph" <Joseph.Liu@emulex.com>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 6:38 PM, Yanmin Zhang
<yanmin_zhang@linux.intel.com> wrote:
> On Tue, 2013-06-04 at 12:04 -0600, Bjorn Helgaas wrote:
>> I'm not sure where we are with this patch.  I think Joseph initially
>> reported a problem (though I haven't actually seen that), and this
>> patch fixed it, so it seems like there's something we want to do here.
> Yes, indeed. We checked Powerpc error handling and plan to use the
> similar method to deal with the issue.
>
> Sorry for replying very late. I move to Android smartphone area and am
> very busy on many top issues.

OK.  Can you point us at a bugzilla or email archive of Joseph's
original problem report, or post it to this thread?  Then maybe
somebody else can pick it up and make progress on this.

Bjorn
