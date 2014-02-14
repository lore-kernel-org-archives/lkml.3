Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaBNOUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:20:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaBNOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:20:30 -0500
Date: Fri, 14 Feb 2014 06:22:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Petr =?utf-8?B?UMOtc2HFmQ==?= <petr.pisar@atlas.cz>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>
Subject: Re: [PATCH] vt: Fix secure clear screen
Message-ID: <20140214142245.GA3785@kroah.com>
References: <1391716883-31383-1-git-send-email-petr.pisar@atlas.cz>
 <20140214103929.GA3933@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214103929.GA3933@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:39:30AM +0100, Pavel Machek wrote:
> Hi!
> 
> > \E[3J console code (secure clear screen) needs to update_screen(vc)
> > in order to write-through blanks into off-screen video memory.
> 
> I guess it is also suitable for stable, right?

I've already marked it as such in my tree.
