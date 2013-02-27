Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3B0J5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:57:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51053 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3B0J5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:57:40 -0500
Date: Wed, 27 Feb 2013 09:56:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Nicolas Pitre <nico@fluxnic.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
Message-ID: <20130227095609.GY17833@n2100.arm.linux.org.uk>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com> <512D1C12.4080109@oberhumer.com> <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg> <87fw0i7n6d.fsf@dell.be.48ers.dk> <20130226221027.GW17833@n2100.arm.linux.org.uk> <1361929234.1924.8.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361929234.1924.8.camel@joe-AO722>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 05:40:34PM -0800, Joe Perches wrote:
> On Tue, 2013-02-26 at 22:10 +0000, Russell King - ARM Linux wrote:
> > So... for a selected kernel version of a particular size, can we please
> > have a comparison between the new LZO code and this LZ4 code, so that
> > we can see whether it's worth updating the LZO code or replacing the
> > LZO code with LZ4?
> 
> How could it be questionable that it's worth updating the LZO code?

Please read the comments against the previous posting of these patches
where I first stated this argument - and with agreement from those
following the thread.  The thread started on 26 Jan 2013.  Thanks.
