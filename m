Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3A2J5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:57:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3A2J5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:57:46 -0500
Date: Tue, 29 Jan 2013 10:57:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rosegardener@freeode.co.uk
Subject: Re: [PATCH 1/4] USB: HID: SRW-S1 Gaming Wheel Driver
In-Reply-To: <926ebbac6c9e2f8db795dd0ef1ba3647.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
References: <1359095687-13398-1-git-send-email-simon@mungewell.org>    <alpine.LNX.2.00.1301281557040.23853@pobox.suse.cz>    <1b4d173a8f4cbb94f6d99ae5c75c10d5.squirrel@mungewell.org>    <alpine.LNX.2.00.1301281750100.23853@pobox.suse.cz>
 <926ebbac6c9e2f8db795dd0ef1ba3647.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, simon@mungewell.org wrote:

> >> I'm happy to change it; However Steelseries' other devices are all
> >> keyboards/mice intended for/marketed at gamers. Since other Steelseries
> >> devices are unlikely to have the same structure (OK I'm just guessing on
> >> that) is it better to keep this driver somewhat 'seperated'?
> >>
> >> I mean, not make life difficult trying to merge keyboard code in with
> >> this
> >> wheel's code.... if that is required in future.
> >
> > I don't think it's strictly required, but it seems to work quite nicely
> > for other drivers as well.
> 
> OK I'll wait a couple of days in-case any more comments come in and re-do
> the patch with the file name 'hid-steelseries.c' towards the end of the
> week.

Works for me. I have finished the review and don't have any other 
comments.

Thanks,

-- 
Jiri Kosina
SUSE Labs
