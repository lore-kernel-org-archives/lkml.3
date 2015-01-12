Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbbALNCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:02:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbALNCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:02:01 -0500
Date: Mon, 12 Jan 2015 13:02:21 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [PATCH 3.16.y-ckt 053/168] ARM: pxa: fix hang on startup with
 DEBUG_LL
Message-ID: <20150112130221.GC2455@charon>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
 <1418653622-21105-54-git-send-email-luis.henriques@canonical.com>
 <1421015948.19708.34.camel@decadent.org.uk>
 <20150112100943.GA2455@charon>
 <878uh8z2pz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878uh8z2pz.fsf@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:56:56AM +0100, Robert Jarzmik wrote:
> Luis Henriques <luis.henriques@canonical.com> writes:
> 
> > On Sun, Jan 11, 2015 at 10:39:08PM +0000, Ben Hutchings wrote:
> > Thanks Ben.
> >
> > Robert, do you think this is a problem?  I can revert this patch as
> > it has already been released in 3.16.7-ckt3.
> Hi Luis,
> 
> No, no problem. It'll be an unused kconfig variable, that's all, as
> debug_ll_io_init() is not called in v3.16 in pxa_map_io().
> 

Great, thanks for your feedback.  And since this variable was already
there anyway, I'll just keep this patch in 3.16 instead of reverting
it.

Cheers,
--
Luís

> Cheers.
> 
> --
> Robert
