Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab3E1R6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:58:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57735 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087Ab3E1R6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:58:53 -0400
Message-ID: <51A4F05C.90001@cogentembedded.com>
Date: Tue, 28 May 2013 21:58:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <edumazet@google.com>, Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core/sock.c: add missing VSOCK string in af_family_*_key_strings
References: <1369753364-10043-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1369753364-10043-1-git-send-email-federico.vaga@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-05-2013 19:02, Federico Vaga wrote:

> The three arrays of strings: af_family_kay_strings,

    s/kay/key/. Maybe whoever applies this could fix the typo...

> af_family_slock_key_strings and af_family_clock_key_strings have not
> VSOCK's string

> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>

WBR, Sergei

