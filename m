Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaFOD7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:59:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36128 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaFOD7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:59:53 -0400
Message-ID: <539D1A28.7040107@zytor.com>
Date: Sat, 14 Jun 2014 20:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Rich Felker <dalias@libc.org>
CC: Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>,
        Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
References: <cover.1402769596.git.luto@amacapital.net> <20140614213000.GO179@brightrain.aerifal.cx> <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com> <539CDC6F.6010501@zytor.com>
In-Reply-To: <539CDC6F.6010501@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2014 04:36 PM, H. Peter Anvin wrote:
> 
> Now, if we can do this without adding another page then that becomes
> much more compelling IMO.  I suspect we can if you are already down to
> 488 bytes.
> 

(If it isn't already the case, was inteded to be part of that...)

	-hpa


