Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaFRWnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaFRWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:43:40 -0400
Message-ID: <53A21610.1040104@redhat.com>
Date: Thu, 19 Jun 2014 00:43:28 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Eric Dumazet <edumazet@google.com>, Chema Gonzalez <chema@google.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: filter: fix upper BPF instruction limit
References: <20140618223457.GA31568@www.outflux.net>
In-Reply-To: <20140618223457.GA31568@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 12:34 AM, Kees Cook wrote:
> The original checks (via sk_chk_filter) for instruction count uses ">",
> not ">=", so changing this in sk_convert_filter has the potential to break
> existing seccomp filters that used exactly BPF_MAXINSNS many instructions.
>
> Fixes: bd4cf0ed331a ("net: filter: rework/optimize internal BPF interpreter's instruction set")
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Daniel Borkmann <dborkman@redhat.com>
