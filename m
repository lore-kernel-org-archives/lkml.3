Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaHTTVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:21:39 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:59252 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaHTTVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhHMCB_3x7479WUkipA+S8i6EwqCWxjzXZSW64Aaa-i-_GR8Q@mail.gmail.com>
References: <1408553745-3536-1-git-send-email-bobby.prani@gmail.com>
 <20140820185955.GA23566@groeck-UX31A> <CAJhHMCB_3x7479WUkipA+S8i6EwqCWxjzXZSW64Aaa-i-_GR8Q@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 15:21:06 -0400
Message-ID: <CAJhHMCDaS3j5g2RMNRhCGxOaTN27oFjeXVdmCkr+xXHzX=f+fQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: booke_wdt: Fix build error as a module
To: Guenter <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        "open list:WATCHDOG DEVICE D..." <linux-watchdog@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 3:18 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> On Wed, Aug 20, 2014 at 2:59 PM, Guenter <linux@roeck-us.net> wrote:

>>
>> Any reason for changing the default from false to true ?
>> Unless you have a reaslly good reason, I don't think that is a good idea.
>
> I don't see where it was being set to false. It is
> uninitialized AFAICT. Does that mean that it is false? (I thought only
> static variables got that default).

Ohk, some googling tells me both global and static variables are
initialized to 0. Makes sense, I will send in a v2



-- 
Pranith
