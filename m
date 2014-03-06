Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaCFJke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:40:34 -0500
Received: from www62.your-server.de ([213.133.104.62]:56050 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaCFJkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:40:31 -0500
Message-ID: <53184281.50103@iogearbox.net>
Date: Thu, 06 Mar 2014 10:40:17 +0100
From: Daniel Borkmann <borkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Markos Chandras <markos.chandras@imgtec.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] tools/net/Makefile: Define PACKAGE to fix bfd build problems
References: <1394097354-5290-1-git-send-email-markos.chandras@imgtec.com>
In-Reply-To: <1394097354-5290-1-git-send-email-markos.chandras@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 10:15 AM, Markos Chandras wrote:
> Fixes the following build problem with binutils-2.24
>
> gcc -Wall -O2   -c -o bpf_jit_disasm.o bpf_jit_disasm.c
> In file included from bpf_jit_disasm.c:25:0:
> /usr/include/bfd.h:35:2: error: #error config.h must be included
> before this header
>   #error config.h must be included before this header
>
> This is similar to commit 3ce711a6abc27abce1554e1d671a8762b7187690
> "perf tools: bfd.h/libbfd detection fails with recent binutils"
>
> See: https://sourceware.org/bugzilla/show_bug.cgi?id=14243
>
> CC: David S. Miller <davem@davemloft.net>
> CC: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>

Acked-by: Daniel Borkmann <dborkman@redhat.com>
