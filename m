Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaDXCnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:43:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63219 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaDXCnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:43:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140424023544.GA2180@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
Date: Wed, 23 Apr 2014 19:43:15 -0700
X-Google-Sender-Auth: 2wWIHZzcEB5sbg_hEakY0qBONeM
Message-ID: <CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
Subject: Re: kaslr should avoid setup_data region
From: Kees Cook <keescook@chromium.org>
To: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 7:35 PM, Dave Young <dyoung@redhat.com> wrote:
> Hello Kees
>
> I'm worrying that setup_data regions could be overwitten by randomize
> kernel base. Would you like to fix it in kaslr code?
>
> One problem is there could be a lot of setup_data regions but current
> mem_avoid is an fixed array.

Sure, can you give me some examples? Seems like it shouldn't be too
hard to have the mem_avoid logic walk additional areas.

-Kees

-- 
Kees Cook
Chrome OS Security
