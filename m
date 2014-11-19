Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaKSBtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:49:03 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48118 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaKSBtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:49:00 -0500
MIME-Version: 1.0
In-Reply-To: <1416361456-11060-3-git-send-email-yinghai@kernel.org>
References: <1416361456-11060-1-git-send-email-yinghai@kernel.org>
	<1416361456-11060-3-git-send-email-yinghai@kernel.org>
Date: Tue, 18 Nov 2014 17:49:00 -0800
X-Google-Sender-Auth: nD53MqL85h6CrCyzLiGUlSuCkNQ
Message-ID: <CAE9FiQVq9QkWKjdxWB5SS7pU1vOMdgqgdwT4n4KmqbgrNBy5gA@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, 64bit: remove highmap for not needed ranges
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 5:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> add cleanup_highmap_late to remove highmap for initmem, around rodata, and
> [_brk_end, all_end).

Sorry, title should be 3/3 instead of 3/4.

Thanks

Yinghai
