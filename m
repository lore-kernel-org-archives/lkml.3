Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaKVOIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:08:18 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39258 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaKVOIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <5470936D.7050909@gmail.com>
References: <5470936D.7050909@gmail.com>
Date: Sat, 22 Nov 2014 15:08:15 +0100
Message-ID: <CAMeQTsa5AQR5-d30dvg+BssgbyUiueUMBwzjcgtJZTHtvZSZAA@mail.gmail.com>
Subject: Re: Remove Code in psb_drb.h
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: nick <xerofoify@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 2:45 PM, nick <xerofoify@gmail.com> wrote:
> Greetings again David and other maintainers,
> I am wondering if I can remove the following code below my message in psb_drv.h as you state it's unneeded in a TODO.
> Cheers Nick
> /* TODO: To get rid of */
> #define PSB_TT_PRIV0_LIMIT       (256*1024*1024)
> #define PSB_TT_PRIV0_PLIMIT      (PSB_TT_PRIV0_LIMIT >> PAGE_SHIFT)

Hi Nick

Yes, those can safely be removed

Cheers
Patrik
