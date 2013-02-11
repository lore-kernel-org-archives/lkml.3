Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab3BKWSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:18:32 -0500
Received: from 8bytes.org ([85.214.48.195]:43786 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784Ab3BKWS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:18:28 -0500
Date: Mon, 11 Feb 2013 23:18:25 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: Re: IO_PAGE_FAULTs on unity mapped regions during amd_iommu_init()
 in Linux 3.4
Message-ID: <20130211221825.GB25591@8bytes.org>
References: <1359657210.6061.3.camel@lorien2>
 <20130201130035.GE25591@8bytes.org>
 <1359743519.2759.38.camel@lorien2>
 <20130205133104.GC2532@8bytes.org>
 <CAKocOOO6Z2LyLYiuQMWf4iv4PAP8h5jbNWxRcSXKgXD1es6GYg@mail.gmail.com>
 <20130206121223.GT25591@8bytes.org>
 <1360204850.2615.10.camel@lorien2>
 <20130211194901.GA18115@kroah.com>
 <1360616223.2950.15.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360616223.2950.15.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb 11 23:18:26 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51196e3222971901713249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 01:57:03PM -0700, Shuah Khan wrote:
> I was hoping Joerg's patch would make it into Linus's tree by now. I
> tested the original patch and did the back-port to 3.4 and 3.0 at the
> same time, before I loose the test system.

I will send the patch with the next merge window. It already has the
stable-tag and should be noticed when it hits Linus' tree. Since Shuah's
system is the only one I know of which actually implements IVMD entries
in the IVRS table the problem seemed not to be important enough to send
another pull-request for v3.8.

Regards,

	Joerg


