Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbaIWX2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:28:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19051 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaIWX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:28:51 -0400
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: hch@infradead.org, bruce.lucas@mongodb.com, adam.radford@avagotech.com,
        kashyap.desai@avagotech.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140923071154.GB3867@infradead.org>
	<1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
	<5421F020.1030309@canonical.com>
Date: Tue, 23 Sep 2014 19:28:04 -0400
In-Reply-To: <5421F020.1030309@canonical.com> (Chris J. Arges's message of
	"Tue, 23 Sep 2014 17:11:44 -0500")
Message-ID: <yq14mvxudbv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris J Arges <chris.j.arges@canonical.com> writes:

Chris> 1) Does this workaround make sense? Perhaps there is an easier
Chris>    way?

One option is to ship a udev rule that disables write same on VMware
disks. However, I don't have a fundamental problem having a workaround
for this in the kernel.

Chris> 2) Do we expect changing max_write_same_blocks at the scsi_disk
Chris>    level to propagate the right write_same flags to other layers
Chris>    such as dm?

No, there's currently no way to communicate that the underlying topology
has changed.

-- 
Martin K. Petersen	Oracle Linux Engineering
