Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaESGhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:37:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39770 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaESGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:37:37 -0400
Date: Sun, 18 May 2014 23:37:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 00/22] atmel_mxt_ts patches, already signed-off
Message-ID: <20140519063733.GA5209@core.coreip.homeip.net>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
 <533D3AF5.9060001@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D3AF5.9060001@itdev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi NIck,

On Thu, Apr 03, 2014 at 11:41:57AM +0100, Nick Dyer wrote:
> Hi Dmitry-
> 
> Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> > Here is a set of patches for atmel_mxt_ts that you've already
> > signed-off. I've rebased them against the most recent mainline and made
> > some very minor changes such as INIT_COMPLETION->reinit_completion.
> 
> It would be useful to have some feedback about this patchset if you have time.
> 

I applied majority of the patches, but dropped 11 (firmware loader) as
it gives trouble in its current for when driver is compiled in and I
also had to drop 12 and 19 because of reject dues to dropping 11.

Thanks.

-- 
Dmitry
