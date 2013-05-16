Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3EPPRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:17:35 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:38245 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3EPPRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <5194D5E6.2070605@amd.com>
References: <51935981.3010808@amd.com>
	<CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com>
	<5193A7C3.4010503@amd.com>
	<CAE9FiQV8x5NPBJVyiv0wE3jyqTvSMNWxgkDQRXf5LxifgCXbtw@mail.gmail.com>
	<5194A9CF.3080509@amd.com>
	<5194D5E6.2070605@amd.com>
Date: Thu, 16 May 2013 08:17:33 -0700
X-Google-Sender-Auth: Pz4icwouIcCjhwVR0SjCQQ1HCGk
Message-ID: <CAE9FiQU4AQmQ6gzUK5gcnVebGPCNjAWFxh5=wXdEbZ_gHM4KaQ@mail.gmail.com>
Subject: Re: 3.9 breaks EFI boot on E350
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Wolfram Gloger <wg@malloc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 5:49 AM, Christian König
<christian.koenig@amd.com> wrote:
> Am 16.05.2013 11:41, schrieb Christian König:
>
> Ups, the board DOES have a serial port, and I've got a log now that shows
> the mentioned patch above isn't the root cause.
>
> After commit 8d57470d8f859635deffe3919d7d4867b488b85a it indeed crashes very
> early in the boot sequence, but commit
> 98e7a989979b185f49e86ddaed2ad6890299d9f0 fixes that and now it crashes while
> trying to unpack the initrd with a completely different backtrace.
>

ok, did you post the boot log for that failing boot ?

Thanks

Yinghai
