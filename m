Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3ITQOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:14:41 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:64453 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab3ITQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:14:38 -0400
Message-ID: <1379693675.8740.2.camel@x220.thuisdomein>
Subject: Re: [PATCH] scsi: fix the build warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Date: Fri, 20 Sep 2013 18:14:35 +0200
In-Reply-To: <CAC5umyhFe-Kb2r-by39S=C9FZmRS+OBqKeE+=hcGvntAKGFyfg@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	 <1377134271.12003.15.camel@joe-AO722> <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	 <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
	 <1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
	 <CAC5umyhVNcwu2k7wEND5DvxRGE+_tyWBNpWjVdQ9DRTyV2qCaw@mail.gmail.com>
	 <1379670782.5938.14.camel@x220.thuisdomein>
	 <CAC5umyhFe-Kb2r-by39S=C9FZmRS+OBqKeE+=hcGvntAKGFyfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Sep 2013 16:14:35.0957 (UTC) FILETIME=[7FC96E50:01CEB61C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 23:32 +0900, Akinobu Mita wrote:
> Yesterday, I sent a patch set which includes two fixes for this issue.
> I wish this to be merged and I'll do my best.

I hadn't yet stumbled onto these patches. Thanks!


Paul Bolle

