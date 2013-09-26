Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3IZWGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:06:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57122 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3IZWGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:06:33 -0400
Date: Wed, 25 Sep 2013 19:10:55 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new binutils needed for arm in 3.12-rc1
To: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <yw1x7ge4x5ir.fsf@unicorn.mansr.com> (from mans@mansr.com on
	Wed Sep 25 10:52:44 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380154255.1974.92@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 10:52:44 AM, Måns Rullgård wrote:
> Rob Landley <rob@landley.net> writes:
> 
> > On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
> >> I'd strongly suggest you make your binutils compatible with newer
> >> instruction syntax instead of making the kernel more complex.
> >
> > Meaning I play whack-a-mole as this becomes permission to depend on
> > endless new gnuisms just because they're there and nobody else is
> > regression testing against them, not because they actually add  
> anything.
> 
> Since when is assembling the instructions correctly, as specified in  
> the
> arch ref, and not in some other random way a gnuism?

If you require current gnome and drop support for older versions (and  
implicitly all other desktops), people start writing stuff that depends  
on systemd. It doesn't matter if the feature you abandoned support for  
the past 10 years of everthing else for wasn't itself provided by  
systemd.

Rob