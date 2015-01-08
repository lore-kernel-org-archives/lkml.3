Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbbAHNyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:54:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbbAHNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:54:23 -0500
Message-ID: <54AE8C0D.2060007@suse.cz>
Date: Thu, 08 Jan 2015 14:54:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: trivial - fix the help doc of CONFIG_CC_OPTIMIZE_FOR_SIZE
References: <1407217387-23479-1-git-send-email-yamada.m@jp.panasonic.com> <20141211104609.A487.AA925319@jp.panasonic.com>
In-Reply-To: <20141211104609.A487.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-11 02:46, Masahiro Yamada wrote:
> Hi Michal,
> 
> Does this seem OK?
> 
> 
> 
> On Tue,  5 Aug 2014 14:43:07 +0900
> Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:
> 
>> Other than GCC, we have another choice, Clang for building the kernel
>> these days.  It seems better to say "compiler" rather than "gcc".
>>
>> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Applied now, sorry for the delay.

Michal

