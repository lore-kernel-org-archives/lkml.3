Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3HVMmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:42:46 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52587 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3HVMmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:42:45 -0400
MIME-Version: 1.0
In-Reply-To: <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
	<yq1ppt68qk9.fsf@sermon.lab.mkp.net>
Date: Thu, 22 Aug 2013 21:42:44 +0900
Message-ID: <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
Subject: Re: [PATCH] scsi: fix the build warning
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>,
        linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Douglas Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/22 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Joe" == Joe Perches <joe@perches.com> writes:
>
> Joe> I don't get this build warning in the first place and I think the
> Joe> scsi_debug file is quite old and probably doesn't need to be
> Joe> changed at all.
>
> guard isn't a boolean, it selects the checksum algorithm used.
>
> Also, I believe Akinobu's recent reorganization of this code in question
> fixed the warning.

Unfortunately, this warning isn't fixed in linux-next, either.
Paul Bolle also sent a patch that fixes the same warning in a little
bit different way.

http://marc.info/?l=linux-scsi&m=137404660520109&w=2
