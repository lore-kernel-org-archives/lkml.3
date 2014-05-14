Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaENBye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 21:54:34 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:64231 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaENByb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 21:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140513201944.GA14023@samfundet.no>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<1399971769-4116-1-git-send-email-lftan@altera.com>
	<20140513201944.GA14023@samfundet.no>
Date: Wed, 14 May 2014 09:54:25 +0800
X-Google-Sender-Auth: 04d6w6pBnBYPGRVmyAmHilnclQI
Message-ID: <CAFiDJ5_5ret2H-OynLMhBStzyDDBLpF6Tsy4bbEUX+mKu2V4uA@mail.gmail.com>
Subject: Re: [PATCH 04/25] avr32: Add 32 bit time_t and clock_t
From: Ley Foon Tan <lftan@altera.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 4:19 AM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Tue 13 May 2014 17:02:49 +0800 or thereabout, Ley Foon Tan wrote:
>> Override time_t and clock_t in include/uapi/asm-generic.
>>
>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>

>
> Quickly looked over some of the other patches in the series, and they all
> seem to add the same. Could this be generic, with the possibility for arch to
> override?
In this patchset, the generic one will be 64 bit (long long). So, the
existing 32 bit users need to override this.

Regards
Ley Foon
