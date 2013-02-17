Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3BQPDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:03:12 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:49556 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3BQPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:03:10 -0500
Date: Sun, 17 Feb 2013 16:04:01 +0100
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>, morbidrsa@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: twl: Fix typo that broke build
Message-ID: <20130217150401.GA1678@blackbook>
References: <20130216202114.GA18727@avionic-0098.mockup.avionic-design.de>
 <1361095693-12385-1-git-send-email-morbidrsa@gmail.com>
 <20130217102630.GA20299@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217102630.GA20299@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 11:26:30AM +0100, Thierry Reding wrote:
> On Sun, Feb 17, 2013 at 11:08:13AM +0100, Johannes Thumshirn wrote:
> > Fix a little type that unfortunately broke the build :-(
> > Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> > ---
> >  drivers/pwm/pwm-twl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Uh... I hadn't noticed and deemed the patch trivial enough so I didn't
> even build test. That'll teach me. =\
> 
> Thierry

Me too.
