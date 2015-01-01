Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbbAAG2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 01:28:31 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65487 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbAAG2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 01:28:30 -0500
Date: Thu, 1 Jan 2015 11:58:16 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>, gregkh@linuxfoundation.org,
        anarey@gmail.com, mcgrof@do-not-panic.com, tapaswenipathak@gmail.com,
        rmfrfs@gmail.com, yejiayily@gmail.com, gdonald@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] staging: rtl8192u: fix whitespace
Message-ID: <20150101062816.GA2710@sudip-PC>
References: <1420060243-10685-2-git-send-email-lstoakes@gmail.com>
 <1420061623-11136-1-git-send-email-lstoakes@gmail.com>
 <20150101044756.GA3645@sudip-PC>
 <1420090813.6066.9.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420090813.6066.9.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 09:40:13PM -0800, Joe Perches wrote:
> On Thu, 2015-01-01 at 10:17 +0530, Sudip Mukherjee wrote:
> > On Wed, Dec 31, 2014 at 09:33:43PM +0000, Lorenzo Stoakes wrote:
> > > This patch fixes warnings/errors raised by checkpatch.pl relating to whitespace
> > > in r8192U_dm.c and additionally it removes inconsistent whitespace
> > > throughout.
> > > 
> > > Additionally some 0x00... padding has been added for alignment to the
> > > edca_setting_* variables.
> > 
> > i may be wrong, but looks like you are doing many different things in the patch, not just whitespace errors.
> > marked a few, please see inline - 
> 
> Don't get carried away with patch type separation
> and please remember to trim your replies to just
> the areas you comment on.
sorry for not trimming that. I noticed the big size while sending, but at that time the damage has already been done.
but is it ok if we mention one thing in the commit log and do other things also? shouldn't we atleast mention that in the commit?

sorry again.
sudip
> 
> 
