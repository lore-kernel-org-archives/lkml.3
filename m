Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbaFKReT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:34:19 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:49091 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaFKReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <539892A7.2030200@zytor.com>
References: <1402463064-31697-1-git-send-email-yinghai@kernel.org>
	<5397F24A.7020407@zytor.com>
	<CAE9FiQX3seRxbotg0OmLFm_WrtY-SoT9uupvZpbAqyur4Hq=aA@mail.gmail.com>
	<539892A7.2030200@zytor.com>
Date: Wed, 11 Jun 2014 10:34:18 -0700
X-Google-Sender-Auth: 3hwzuB7_CqCMrD6PqRI5mAWtkXM
Message-ID: <CAE9FiQV3G+eg8+G5QUv_wtmF2eEeXU_biUS=3v_4zzGFt3VjQw@mail.gmail.com>
Subject: Re: [PATCH] x86: Find correct 64 bit ramdisk address for microcode
 early update
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:32 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> It is not about loading over 4G, it is that some kinds of code (in
> particular accessing global variables) from the early microcode loading
> code doesn't work on 32 bits, so it needs to be tested.

Ok, will test 32bit path.

Thanks

Yinghai
