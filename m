Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3LTKs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:48:58 -0500
Received: from multi.imgtec.com ([194.200.65.239]:18898 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab3LTKsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:48:54 -0500
Message-ID: <52B4208B.1080801@imgtec.com>
Date: Fri, 20 Dec 2013 10:48:43 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: lib: add "umoddi3.S" file for __umoddi3()
References: <52B2E0FA.7090805@gmail.com> <52B2E3DB.7010008@imgtec.com> <52B2F6B7.1050802@gmail.com> <52B2F8DC.8060006@imgtec.com> <52B3A0EA.9010801@gmail.com> <52B40E44.9040603@imgtec.com> <52B419DE.8050706@gmail.com>
In-Reply-To: <52B419DE.8050706@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_20_10_48_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/13 10:20, Chen Gang wrote:
> Hmm... but do you know why we need some 64-bit functions which are
> implemented under "arch/metag/lib/*.S"? can we use <linux/math64.h>
> instead of them? (e.g 64-bit '/').

If you look at linux/math64.h you'll see it only implements division
operations. The other 64 bit operations like shift, compare, and
multiply are relatively cheap so are implemented as intrinsics instead.

Cheers
James

