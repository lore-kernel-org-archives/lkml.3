Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3EANaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 09:30:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48323 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3EANaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 09:30:20 -0400
Date: Wed, 1 May 2013 06:30:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/7] tty: xuartps: Sort #includes alphabetically
Message-ID: <20130501133016.GA2977@kroah.com>
References: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
 <1367366284-28304-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130501000048.GA1840@kroah.com>
 <cbd8c55c-066b-4396-9a4b-97d58a93b573@DB8EHSMHS005.ehs.local>
 <20130501002321.GB7435@kroah.com>
 <5180BB21.2080306@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5180BB21.2080306@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 08:50:09AM +0200, Michal Simek wrote:
> On 05/01/2013 02:23 AM, Greg Kroah-Hartman wrote:
> > On Tue, Apr 30, 2013 at 05:05:40PM -0700, Sören Brinkmann wrote:
> >> On Tue, Apr 30, 2013 at 05:00:48PM -0700, Greg Kroah-Hartman wrote:
> >>> On Tue, Apr 30, 2013 at 04:57:58PM -0700, Soren Brinkmann wrote:
> >>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>> CC: Jiri Slaby <jslaby@suse.cz>
> >>>> CC: linux-serial@vger.kernel.org
> >>>
> >>> Why would you need/want to do this?
> >> I often come across duplicated includes. Having some kind of order helps
> >> avoiding that, imho.
> > 
> > We have a tool to handle duplicated includes, no need to put them in
> > sorted order for them to be detected.
> 
> What's the name of tool which does that?
> I have seen results from it but have never tried to find it out name and
> how to use it.

scripts/checkincludes.pl

