Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3BPTlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 14:41:22 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38169 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3BPTlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 14:41:21 -0500
Date: Sat, 16 Feb 2013 20:42:10 +0100
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>, morbidrsa@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: twl: Use to_twl() instead of container_of()
Message-ID: <20130216194210.GA5679@blackbook>
References: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
 <20130216185618.GA17744@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130216185618.GA17744@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 07:56:18PM +0100, Thierry Reding wrote:
> On Sat, Feb 16, 2013 at 07:20:51PM +0100, Johannes Thumshirn wrote:
> > In twl6030_pwm_disable() use to_twl() instead of container_of() like in the
> > rest of the driver.
> > 
> > Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> > ---
> >  drivers/pwm/pwm-twl.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Hi Johannes,
> 
> I see that container_of() is also still used in twl4030_pwm_free() and
> twl6030_pwm_enable(). Would you mind fixing those up as well?
> 
> Thierry

Oh sorry haven't seen them, I'll take care of it.

Johannes
