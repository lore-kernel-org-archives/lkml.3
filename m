Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaGZQpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:45:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47669 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaGZQo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:44:59 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: poma <pomidorabelisima@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69 kmem_cache_create+0x1a9/0x330()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com>
	<20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de>
	<53C97D34.5040707@gmail.com>
	<1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	<20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
	<20140726162102.GA7126@lst.de>
Date: Sat, 26 Jul 2014 12:44:34 -0400
In-Reply-To: <20140726162102.GA7126@lst.de> (Christoph Hellwig's message of
	"Sat, 26 Jul 2014 18:21:02 +0200")
Message-ID: <yq1k370dq8d.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Here's a formal one.  James, can I get your signoff for it?

Christoph> Vladimir, can I get a reviewed-by from you (or anyone else)?

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
