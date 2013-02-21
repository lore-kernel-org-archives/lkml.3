Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3BULiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:38:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab3BULiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:38:04 -0500
Message-ID: <512606DF.5050706@redhat.com>
Date: Thu, 21 Feb 2013 12:37:03 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>
Subject: New copyfile system call - discuss before LSF?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have debated the need to have a system call to allow for offloading copy 
operations, for example to an NFS server (part to the new NFS 4.2 
specification), SCSI target device (two different SCSI commands do this), local 
file systems (reflink, etc) and I suspect many other possible parts of the stack 
could implement this.

The earliest discussion of such a system call I saw happened back in 2001, I 
know we had another more recent flurry (2-3 years back?) as well that got 
tangled up and died away.

Given the new popularity of this in storage devices and the use case for virt 
guests, any chance to get a proposal floated this year that might be able to 
land upstream in our life times :) ?

Ric



