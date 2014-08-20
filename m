Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaHTN3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:29:44 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49258 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaHTN3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140820132527.GB8664@roeck-us.net>
References: <1408504328-11324-1-git-send-email-bobby.prani@gmail.com> <20140820132527.GB8664@roeck-us.net>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 09:29:10 -0400
Message-ID: <CAJhHMCB9bszAogzFcAMR9G6jj5JtZy=LFkYi=-ZiixWaukJR-A@mail.gmail.com>
Subject: Re: [PATCH] booke_wdt: Fix build failure as a module
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        "open list:WATCHDOG DEVICE D..." <linux-watchdog@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 9:25 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Aug 19, 2014 at 11:12:07PM -0400, Pranith Kumar wrote:
>> Building booke_wdt fails when trying to build as a module as there is no
>> early_param() in module. Fix by enclosing within MODULE check.
>>
> Might make more sense to replace the early_param with a normal module parameter.
> Taking the module parameter away if the driver is built as module seems to be
> a bit excessive.
>
> Any idea why early_param was chosen over a standard module parameter ?


I didn't really investigate. This showed up in a randconfig build
error. I will try to convert this to module param. Thanks!

-- 
Pranith
