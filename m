Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab3BZAEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:04:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab3BZAD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:03:59 -0500
Date: Mon, 25 Feb 2013 16:03:01 -0800
From: Zach Brown <zab@redhat.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ric Wheeler <rwheeler@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130226000301.GG1658@lenny.home.zabbo.net>
References: <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <512BD44C.40907@amacapital.net>
 <512BDC82.5060203@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA928699C17@sacexcmbx05-prd.hq.netapp.com>
 <CALCETrVXxdJ0Pg7wLS9T7mHRj8Ak2M1Yn3EPE_eBmHN3L9+70A@mail.gmail.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA92869CE90@sacexcmbx05-prd.hq.netapp.com>
 <CALCETrU-cfYeEnh6DF4f6z=d0gJsPd1rfShbPDYF4kX8R+8eRQ@mail.gmail.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA92869CFCE@sacexcmbx05-prd.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA92869CFCE@sacexcmbx05-prd.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   I think it would be neat if it couldn't
> > corrupt data.
> 
> It would also be neat if the moon were made of cheese...

And there we have the lsf2013 t-shirt slogan.  I think we're done here!

- z
