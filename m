Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3HVBZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:25:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40410 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3HVBZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:25:38 -0400
To: Joe Perches <joe@perches.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-scsi@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, akinobu.mita@gmail.com
Subject: Re: [PATCH] scsi: fix the build warning
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
Date: Wed, 21 Aug 2013 21:25:26 -0400
In-Reply-To: <1377134271.12003.15.camel@joe-AO722> (Joe Perches's message of
	"Wed, 21 Aug 2013 18:17:51 -0700")
Message-ID: <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joe" == Joe Perches <joe@perches.com> writes:

Joe> I don't get this build warning in the first place and I think the
Joe> scsi_debug file is quite old and probably doesn't need to be
Joe> changed at all.

guard isn't a boolean, it selects the checksum algorithm used.

Also, I believe Akinobu's recent reorganization of this code in question
fixed the warning.

-- 
Martin K. Petersen	Oracle Linux Engineering
