Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbbALP0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:26:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35225 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbbALP0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:26:02 -0500
Date: Mon, 12 Jan 2015 16:25:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] out out damn perl
Message-ID: <20150112152557.GA4425@pd.tnic>
References: <54AC72AF.5090609@landley.net>
 <20150112151625.GA30247@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150112151625.GA30247@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:16:25AM -0500, Lennart Sorensen wrote:
> On Tue, Jan 06, 2015 at 05:41:35PM -0600, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> > 
> > Commit e6023367d779 added perl back to the kernel build in -rc6.
> > Replace 39 lines of perl with 4 lines of shell script.
> 
> Maybe checkpatch should be updated to look for perl. :)

And patch itself out. Yep, good idea. :-D

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
