Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaEBQM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:12:57 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40062 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaEBQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <53632F50.9010506@zytor.com>
References: <1398984278-29319-1-git-send-email-andi@firstfloor.org>
	<CA+55aFwc5znv-mqSX9nwVWNoXRUekoTiia4vgLgxauQcVZD15w@mail.gmail.com>
	<53632F50.9010506@zytor.com>
Date: Fri, 2 May 2014 09:12:54 -0700
X-Google-Sender-Auth: bTUpS9zSpxazI6OX1rKmgxbeY00
Message-ID: <CA+55aFwDA_X2tDZAjiqEGr_7LbWcCxKn=hL7m0E6ddpCsA0N7w@mail.gmail.com>
Subject: Re: Remove __visible from asmlinkage for 3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 10:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> How about I put it into tip/urgent, but for next week's pull so it gets
> some time to cook first...

Sounds like a good plan to me,

               Linus
