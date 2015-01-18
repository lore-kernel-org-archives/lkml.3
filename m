Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbbARDHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 22:07:38 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62301 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbARDHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 22:07:36 -0500
From: Andrew Milkovich <amilkovich@gmail.com>
X-Google-Original-From: Andrew Milkovich <root@zenbook.hsd1.ca.comcast.net>
Date: Sat, 17 Jan 2015 19:07:33 -0800
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Milkovich <amilkovich@gmail.com>, benjamin.romer@unisys.com,
        david.kershner@unisys.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150118030733.GB1937@zenbook.hsd1.ca.comcast.net>
References: <1421470690-9534-1-git-send-email-amilkovich@gmail.com>
 <20150118002235.GA10241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118002235.GA10241@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Sat, Jan 17, 2015 at 04:22:35PM -0800, Greg KH wrote:
> On Fri, Jan 16, 2015 at 08:58:10PM -0800, Andrew Milkovich wrote:
> > Fixed coding style errors per checkpatch.pl. Inline comments removed; chanptr
> > comment is implied by the first argument being the channel. No parent bus
> > comment is already understood by the argument being NULL.
> > 
> > Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
> > ---
> >  drivers/staging/unisys/virtpci/virtpci.c | 24 ++++++++----------------
> >  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> This doesn't apply to my staging-testing branch at all, sorry.
> 
> greg k-h

Looks like the '-f' switch on checkpatch.pl was the reason I was getting
whitespace errors.

I'll resubmit the proper patch.
