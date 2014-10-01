Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaJAIuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:50:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaJAIuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:50:20 -0400
Date: Wed, 1 Oct 2014 10:50:18 +0200
From: Jan Kara <jack@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Dmitry Monakhov <dmonakhov@openvz.org>, linux-scsi@vger.kernel.org
Subject: Re: ext4: 3.17? problems
Message-ID: <20141001085018.GB17405@quack.suse.cz>
References: <20140929114408.GC2738@quack.suse.cz>
 <87iok6ojis.fsf@openvz.org>
 <20140928124658.GB6694@thunk.org>
 <20140930210108.GB14283@amd>
 <20140930231801.GB729@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930231801.GB729@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-09-14 20:18:01, Henrique de Moraes Holschuh wrote:
> On Tue, 30 Sep 2014, Pavel Machek wrote:
> > > > So I had to hard power-down the machine. That should be perfectly
> > > > safe, as ext4 has a journal, and this is plain SATA disk, right?
> > >   Yes, it should be safe.
> > 
> > Good.
> 
> ...
> 
> > Is there some phase during shutdown where journalling no longer
> > protects fs integrity?
> 
> Hmm... what kind of backing device?  Because I have Crucial/Micron M500 SSDs
> here that _always_ complain (in a SMART counter/attribute) that they have
> been subject to a sudden poweroff *when subject to a normal system
> shutdown*.
> 
> This is scaring me a great deal.  Are we doing something different for SSDs
> in the scsi-sd or libata shutdown paths?
  Nothing I'm aware of but this is more a question for SCSI guys (added to
CC).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
