Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaFLGLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:11:23 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35183 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaFLGLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:11:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV3G+eg8+G5QUv_wtmF2eEeXU_biUS=3v_4zzGFt3VjQw@mail.gmail.com>
References: <1402463064-31697-1-git-send-email-yinghai@kernel.org>
	<5397F24A.7020407@zytor.com>
	<CAE9FiQX3seRxbotg0OmLFm_WrtY-SoT9uupvZpbAqyur4Hq=aA@mail.gmail.com>
	<539892A7.2030200@zytor.com>
	<CAE9FiQV3G+eg8+G5QUv_wtmF2eEeXU_biUS=3v_4zzGFt3VjQw@mail.gmail.com>
Date: Wed, 11 Jun 2014 23:11:21 -0700
X-Google-Sender-Auth: JhboV-uCvtKPyGtVHXtqagjNxI8
Message-ID: <CAE9FiQW=yMSAHsbokjMp_-+xfVVWf29EhEtNErZS+cC4s4FMjQ@mail.gmail.com>
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

On Wed, Jun 11, 2014 at 10:34 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Jun 11, 2014 at 10:32 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> It is not about loading over 4G, it is that some kinds of code (in
>> particular accessing global variables) from the early microcode loading
>> code doesn't work on 32 bits, so it needs to be tested.
>
> Ok, will test 32bit path.

Hi Peter,

Just checked, 32bit path works with the patch.
To be exactly Intel 32bit path works.

Thanks

Yinghai
