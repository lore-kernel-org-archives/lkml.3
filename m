Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3GPKCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:02:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3GPKCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:02:47 -0400
Date: Tue, 16 Jul 2013 12:02:44 +0200
From: Jan Kara <jack@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130716100244.GA25632@quack.suse.cz>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <1373951852.2148.9.camel@dabdike>
 <20130716062058.GB19052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716062058.GB19052@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-07-13 23:20:58, Greg KH wrote:
> I think the real stable issue that _everyone_ keeps ignoring, is my
> original complaint, in that people are using the -rc1 merge window to
> get fixes in they should have sent to Linus for .0.
> 
> I don't see anything you have written so far that will help resolve that
> issue, which is not good, as that needs to be taken care of.
  Well, I remember Linus has said several times in case of more risky fixes
that he'd rather see them in -rc1 with -stable tag than merging them (very)
late in the -rc series. And frankly if the patch gets in in the merge
window it doesn't get too much real testing before it is released in stable
so how to treat such patches is a question. So I think we need to find a
balance between what you and Linus ask for.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
