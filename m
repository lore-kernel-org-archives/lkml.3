Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3KLPiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:38:08 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:32816 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3KLPiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:38:03 -0500
Date: Tue, 12 Nov 2013 15:37:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Add defines for microphone
 detection levels
Message-ID: <20131112153757.GA3863@lee--X1>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5280AAAF.8040005@samsung.com>
 <20131111105356.GB22184@lee--X1>
 <20131111110652.GD6549@opensource.wolfsonmicro.com>
 <20131111111503.GC22184@lee--X1>
 <5280BE00.8030002@samsung.com>
 <20131111112638.GE22184@lee--X1>
 <20131112142554.GE6549@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131112142554.GE6549@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Charles Keepax wrote:

> On Mon, Nov 11, 2013 at 11:26:38AM +0000, Lee Jones wrote:
> > > >>> I'm inclined to agree with you though, so if you want to send a patch
> > > >>> based on v3.14-rc1 I'd be happy to accept it.
> > > >>
> > > >> Apologies for causing confusion here I checked your tree for the
> > > >> patch and didn't see it, so I assumed you had decided not to
> > > >> apply it. I must have missed it some how.
> > > > 
> > > > So I am partly to blame here. My public repos sometimes aren't as
> > > > up-to-date and my private ones, but if I've replied to a patch and
> > > > said I've applied it, I inevitably have.
> > > > 
> > > But this patch has only the dependency of extcon subsystem.
> > > At least, you have to get 'Acked-by' or 'Signed-off-by' from
> > > subsystem maintainer. I didn't agree applying this patch on mainline tree.
> > 
> > Please see my other mail.
> 
> Sorry for the sake of clarity, we are backing out the patch and I
> should send a fresh one?

I don't think there is a requirement to resend, but Chanwoo is right,
I can't take this patch. It's up to him.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
