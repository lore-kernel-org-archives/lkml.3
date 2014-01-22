Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaAVUr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:47:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16798 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbaAVUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:47:24 -0500
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going beyond 4096 bytes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	<20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	<20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
Date: Wed, 22 Jan 2014 15:47:12 -0500
In-Reply-To: <52DFDCA6.1050204@redhat.com> (Ric Wheeler's message of "Wed, 22
	Jan 2014 09:58:46 -0500")
Message-ID: <yq138kfbv73.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:

Ric> I will have to see if I can get a storage vendor to make a public
Ric> statement, but there are vendors hoping to see this land in Linux
Ric> in the next few years. I assume that anyone with a shipping device
Ric> will have to at least emulate the 4KB sector size for years to
Ric> come, but that there might be a significant performance win for
Ric> platforms that can do a larger block.

I am aware of two companies that already created devices with 8KB
logical blocks and expected Linux to work. I had to do some explaining.

I agree with Ric that this is something we'll need to address sooner
rather than later.

-- 
Martin K. Petersen	Oracle Linux Engineering
