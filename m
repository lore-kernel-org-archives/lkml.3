Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3HVO1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:27:16 -0400
Received: from mx2.parallels.com ([199.115.105.18]:55694 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3HVO1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:27:14 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Paul Bolle" <pebolle@tiscali.nl>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: fix the build warning
Thread-Topic: [PATCH] scsi: fix the build warning
Thread-Index: AQHOntZ6aPBXIB1fJk2u5Yl6j9wNrZmhod0AgAAdKoA=
Date: Thu, 22 Aug 2013 14:27:07 +0000
Message-ID: <1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	 <1377134271.12003.15.camel@joe-AO722> <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	 <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
In-Reply-To: <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.17.213.192]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DBB14323A0DE6049A4B6245ABACF6117@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 21:42 +0900, Akinobu Mita wrote:
> 2013/8/22 Martin K. Petersen <martin.petersen@oracle.com>:
> >>>>>> "Joe" == Joe Perches <joe@perches.com> writes:
> >
> > Joe> I don't get this build warning in the first place and I think the
> > Joe> scsi_debug file is quite old and probably doesn't need to be
> > Joe> changed at all.
> >
> > guard isn't a boolean, it selects the checksum algorithm used.
> >
> > Also, I believe Akinobu's recent reorganization of this code in question
> > fixed the warning.
> 
> Unfortunately, this warning isn't fixed in linux-next, either.
> Paul Bolle also sent a patch that fixes the same warning in a little
> bit different way.

Well, it is and it isn't.  Whether you see the warning seems to depend
on how gcc was built.  My take is that an impossible default case just
to keep some versions of gcc quiet is a bit pointless.

James

