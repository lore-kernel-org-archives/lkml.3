Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3BVSXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:23:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671Ab3BVSXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:23:01 -0500
Date: Fri, 22 Feb 2013 10:22:10 -0800
From: Zach Brown <zab@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130222182210.GA22221@lenny.home.zabbo.net>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <51273EBB.1010305@redhat.com>
 <51273FE3.8000306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51273FE3.8000306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems to be suspiciously close to a clear consensus on how to
> move forward after many years of spinning our wheels. Anyone want to
> promote an actual patch before we change our collective minds?

It seems like we'd want to start with the exisiting (presumably
bitrotten) prototypes that Trond has for nfs and that Martin has for
block->scsi.  Mash the new syscall on top of and get them working in
current mainline.

I'd be happy to take responsibility for making forward progress if no
one else has the bandwidth.

Trond, Martin, would that make sense?  Are the most recent versions of
the prototypes available somewhere?

- z
