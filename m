Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3H2Sc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:32:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40716 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212Ab3H2Sc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:32:26 -0400
Message-ID: <521F9390.9030409@zytor.com>
Date: Thu, 29 Aug 2013 11:31:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
CC: llvmlinux@lists.linuxfoundation.org, pageexec@freemail.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with
 clang.
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de> <3804425.88935NyK6A@aragorn.auenland.lan> <521F9076.1050405@zytor.com> <2571698.tomcdIIDB2@aragorn.auenland.lan>
In-Reply-To: <2571698.tomcdIIDB2@aragorn.auenland.lan>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:23 AM, Jan-Simon Möller wrote:
> 
>> Actually, it might be a bad idea.  In C embedded assembly we sometimes
>> need %% and sometimes %.
> 
> You speak of arch/x86/kvm/vmx.c, right ?
> 

Well, in general.

	-hpa


