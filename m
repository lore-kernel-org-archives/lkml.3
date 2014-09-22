Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaIVSTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:19:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIVSTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:19:32 -0400
Date: Mon, 22 Sep 2014 11:19:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vget.kernel.org,
        bruce.lucas@mongodb.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptfusion: enable no_write_same in scsi_host_template
Message-ID: <20140922181929.GA11319@infradead.org>
References: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com>
 <20140922180220.GA10166@infradead.org>
 <5420679D.3070406@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5420679D.3070406@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:17:01PM -0500, Chris J Arges wrote:
> > 
> I've only been able to reproduce this on VMWare. There is a pretty
> straightforward reproducer in the BugLink if there is any interest in
> verifying on hardware.
> 
> How would you recommending blacklisting only VMWare guests in this case?

Can you check what PCI subdevice and subvendor IDs the device you can
reproduce it with have?  If the subvendor is Vmware that would be easy,
if not the Avago people might be able to help with a device specific
VMware identification.  If that fails we have kernel helpers to
identify the hypervisor, but I'd rather avoid that as it would also
trigger for PCI pass through devices.

