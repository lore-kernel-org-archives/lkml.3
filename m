Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3BVWsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:48:24 -0500
Received: from mx12.netapp.com ([216.240.18.77]:55228 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab3BVWsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:48:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,717,1355126400"; 
   d="scan'208";a="25317006"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Zach Brown <zab@redhat.com>, Ric Wheeler <rwheeler@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, "Joel Becker" <jlbec@evilplan.org>
Subject: RE: New copyfile system call - discuss before LSF?
Thread-Topic: New copyfile system call - discuss before LSF?
Thread-Index: AQHOECfzherspfmEjEqBTzfvhb3EUJiE2wAAgAASTQCAAFTBgIAADekAgAAaWoCAAL7IgIAAAWGAgACOYAD//8MR0A==
Date: Fri, 22 Feb 2013 22:48:18 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DCDA7@SACEXCMBX04-PRD.hq.netapp.com>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net> <51273EBB.1010305@redhat.com>
 <51273FE3.8000306@redhat.com> <20130222182210.GA22221@lenny.home.zabbo.net>
In-Reply-To: <20130222182210.GA22221@lenny.home.zabbo.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Zach Brown [mailto:zab@redhat.com]
> Sent: Friday, February 22, 2013 1:22 PM
> To: Ric Wheeler
> Cc: Paolo Bonzini; Myklebust, Trond; Linux FS Devel; linux-
> kernel@vger.kernel.org; Chris L. Mason; Christoph Hellwig; Alexander Viro;
> Martin K. Petersen; Hannes Reinecke; Joel Becker
> Subject: Re: New copyfile system call - discuss before LSF?
> 
> > This seems to be suspiciously close to a clear consensus on how to
> > move forward after many years of spinning our wheels. Anyone want to
> > promote an actual patch before we change our collective minds?
> 
> It seems like we'd want to start with the exisiting (presumably
> bitrotten) prototypes that Trond has for nfs and that Martin has for
> block->scsi.  Mash the new syscall on top of and get them working in
> current mainline.
> 
> I'd be happy to take responsibility for making forward progress if no one else
> has the bandwidth.
> 
> Trond, Martin, would that make sense?  Are the most recent versions of the
> prototypes available somewhere?

Hi Zach,

The wildly bitrotten NFS copyfile prototype can be found on

    ftp://ftp.netapp.com/frm-ntap/opensource/linux_copyfileat/v2/linux_copyfileat_v2.tgz

Please open with extreme caution and apply the resulting patches to a Linux 2.6.34.2 kernel...

Cheers
   Trond
