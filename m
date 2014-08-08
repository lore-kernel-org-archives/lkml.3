Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaHHQUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:20:03 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34511 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbaHHQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:20:00 -0400
Date: Fri, 8 Aug 2014 09:19:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: nick.dyer@itdev.co.uk
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/2] Input: atmel_mxt_ts - simplify mxt_initialize a bit
Message-ID: <20140808161956.GB26820@core.coreip.homeip.net>
References: <20140807165932.GA23198@core.coreip.homeip.net>
 <1407513483-30050-1-git-send-email-nick.dyer@itdev.co.uk>
 <1407513483-30050-2-git-send-email-nick.dyer@itdev.co.uk>
 <20140808161901.GA26820@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808161901.GA26820@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:19:01AM -0700, Dmitry Torokhov wrote:
> On Fri, Aug 08, 2014 at 04:58:02PM +0100, nick.dyer@itdev.co.uk wrote:
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > I think having control flow with 2 goto/labels/flags is quite hard to read,
> > this version is a bit more readable IMO.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> 
> Nick, are there any changes from the version I posted? (If not then I do
> not need to drop my patch from the queue and re-import this one).

Ah, sorry, should have read all my email before replying...

-- 
Dmitry
