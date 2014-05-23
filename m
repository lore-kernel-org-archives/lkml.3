Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaEWI7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:59:16 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62916 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaEWI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140523083208.GM19747@lee--X1>
References: <CACRpkdZTez-OJgjNV8jKxgFEXhyXdsnv5bwSdLH_dRfok1u24g@mail.gmail.com>
	<20140523083208.GM19747@lee--X1>
Date: Fri, 23 May 2014 10:59:11 +0200
Message-ID: <CACRpkdaWOCxyoVoPo+sUfP5K-QJ3gSr+sfz+iiSOQChtVCeyNA@mail.gmail.com>
Subject: Re: [GIT PULL] sound branch of STMPE cleanups
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:32 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Nope, this branch is broken too.  I don't think this is a merge error,
> I think it's programmer error (even the greats make mistakes =:-) ).

Yeah you're right :-( :-(

Sorry for the mess.

> In the mean time, it might be worth you looking at your build system,
> as it seems to be overlooking drivers/mfd/stmpe.c.

This indeed seems to be the problem.

Thanks for covering up my stupid mistakes, I owe you one.

Yours,
Linus Walleij
