Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaIXISp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:18:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaIXISm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:18:42 -0400
Date: Wed, 24 Sep 2014 01:18:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris J Arges <chris.j.arges@canonical.com>, hch@infradead.org,
        bruce.lucas@mongodb.com, adam.radford@avagotech.com,
        kashyap.desai@avagotech.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
Message-ID: <20140924081837.GB14285@infradead.org>
References: <20140923071154.GB3867@infradead.org>
 <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
 <5421F020.1030309@canonical.com>
 <yq14mvxudbv.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq14mvxudbv.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:28:04PM -0400, Martin K. Petersen wrote:
> >>>>> "Chris" == Chris J Arges <chris.j.arges@canonical.com> writes:
> 
> Chris> 1) Does this workaround make sense? Perhaps there is an easier
> Chris>    way?
> 
> One option is to ship a udev rule that disables write same on VMware
> disks. However, I don't have a fundamental problem having a workaround
> for this in the kernel.

This sounds way to scary to me.

I'd like to add Chris latests patch and Cc it to stable.

Martin, given that you're ok with it can you give me a review?
