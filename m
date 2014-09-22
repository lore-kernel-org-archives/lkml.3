Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaIVAv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:51:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53330 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaIVAv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:51:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <87tx40h4mz.fsf@tassilo.jf.intel.com>
References: <20140918135202.GA26038@khazad-dum.debian.net> <87tx40h4mz.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 21 Sep 2014 17:51:12 -0700
To: Andi Kleen <andi@firstfloor.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Message-ID: <06e07006-342a-4041-8592-37dd16866be6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

He said *outside* of the early update mechanism.

On September 21, 2014 5:37:24 PM PDT, Andi Kleen <andi@firstfloor.org> wrote:
>Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:
>
>
>>     And yes, this means we will kill support for microcode updates
>>     outside of the initramfs/early-initramfs, at least in Debian,
>>     and likely in Ubuntu.
>
>You got it totally backwards. initramfs updating should handle this
>microcode update just fine, as it happens before the kernel 
>scans the cpuids. Just don't update it later.
>
>Nothing else is needed.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
