Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaJXTyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:54:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42514 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaJXTyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:54:13 -0400
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Slow dc3dd in 3.18 on x86
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <544AA317.8070609@gmail.com>
Date: Fri, 24 Oct 2014 15:54:08 -0400
In-Reply-To: <544AA317.8070609@gmail.com> (Michael L. Semon's message of "Fri,
	24 Oct 2014 15:05:59 -0400")
Message-ID: <yq1r3xxtfa7.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michael" == Michael L Semon <mlsemon35@gmail.com> writes:

Michael> This week, a simple `dc3dd wipe=/dev/sda5` operation had speeds
Michael> cut from 10-15 MB/s down to less than 1.8 MB/s.  With this
Michael> method, syncs took so long that magic SysRq keys were needed to
Michael> stop the PC.  A bisect let me here:

That commit itself doesn't do anything.

I was concerned that somehow integrity got enabled by accident and you
were bogged down by checksum calculations but I see no evidence that
this would be happening. Ran a few tests on ATA systems here.

So I'm puzzled.

Please let me know if the disk has an integrity profile in sysfs.

-- 
Martin K. Petersen	Oracle Linux Engineering
