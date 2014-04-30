Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaD3D7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:59:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56530 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaD3D7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAG4AFWaemUiR1HTx5dUUQf3V4twuwuiBdtDLNEeEoF-ikTThpQ@mail.gmail.com>
References: <CAG4AFWaemUiR1HTx5dUUQf3V4twuwuiBdtDLNEeEoF-ikTThpQ@mail.gmail.com>
Date: Tue, 29 Apr 2014 23:59:09 -0400
Message-ID: <CAG4AFWa0MGEZvyqq5VWCpsQGFCGbu-16V_djv_sEW6YV3VDSGw@mail.gmail.com>
Subject: Re: Is heap_stack_gap useless?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to kernel-development list.

The original email wasn't plaintext mode and was rejected by
kernel-development list.

On Tue, Apr 29, 2014 at 11:31 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> Hi,
>
> I noticed this variable, defined in mm/nommu.c,
>
> mm/nommu.c:int heap_stack_gap = 0;
>
> This variable only shows up once, and never shows up in elsewhere.
>
> Can some one tell me is this useless? If so, I will submit a patch to remove
> it.
>
> -Jidong
