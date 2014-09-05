Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaIEREB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:04:01 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51143 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaIERD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <54095A5B.4030606@redhat.com>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
	<20140904100137.GK3001@console-pimps.org>
	<5408D299.5000300@zytor.com>
	<20140904212925.GL3001@console-pimps.org>
	<CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
	<20140905054749.GA4498@ad.chargestorm.se>
	<54095A5B.4030606@redhat.com>
Date: Fri, 5 Sep 2014 10:03:58 -0700
X-Google-Sender-Auth: KPnBb7dqgXdZZ3GhTmru-m0RgNE
Message-ID: <CAE9FiQV7XLwKsYWprmKAkZGGyuFeK=o_b1_ABMbEGVZzZxtp2w@mail.gmail.com>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
From: Yinghai Lu <yinghai@kernel.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Anders Darander <anders@chargestorm.se>,
        Matt Fleming <matt@console-pimps.org>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 11:38 PM, Laszlo Ersek <lersek@redhat.com> wrote:
> On 09/05/14 07:47, Anders Darander wrote:
> In other words, the rounding up of the kernel will be undone in a
> "somewhat higher level" driver in the firmware, and the request size
> that reaches DiskIo (the "lowel level driver") remains the same.

Thanks for explanation.

Is there any way to check if EFI firmware have your fix from some calling?

Thanks

Yinghai
