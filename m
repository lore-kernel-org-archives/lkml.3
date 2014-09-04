Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaIDUWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:22:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37905 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbaIDUWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:22:19 -0400
Message-ID: <5408C9C4.1010705@zytor.com>
Date: Thu, 04 Sep 2014 13:21:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Toshi Kani <toshi.kani@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, akpm@linuxfoundation.org,
        arnd@arndb.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        jgross@suse.com, stefan.bader@canonical.com, luto@amacapital.net,
        konrad.wilk@oracle.com
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com> <1409855739-8985-2-git-send-email-toshi.kani@hp.com> <20140904201123.GA9116@khazad-dum.debian.net>
In-Reply-To: <20140904201123.GA9116@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 01:11 PM, Henrique de Moraes Holschuh wrote:
> 
> I am worried of uncharted territory, here.  I'd actually advocate for not
> enabling the upper four PAT entries on IA-32 at all, unless Windows 9X / XP
> is using them as well.  Is this a real concern, or am I being overly
> cautious?
> 

It is extremely unlikely that we'd have PAT issues in 32-bit mode and
not in 64-bit mode on the same CPU.

As far as I know, the current blacklist rule is very conservative due to
lack of testing more than anything else.

	-hpa

