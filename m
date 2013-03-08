Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab3CHQim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:38:42 -0500
Received: from mail1.windriver.com ([147.11.146.13]:56179 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab3CHQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:38:41 -0500
Message-ID: <513A1411.7060403@windriver.com>
Date: Fri, 8 Mar 2013 11:38:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com> <20130227231826.GA30154@lizard.fhda.edu> <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com> <20130228013514.GA7556@lizard.fhda.edu> <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com> <20130228025931.GA13764@lizard.gateway.2wire.net>
In-Reply-To: <20130228025931.GA13764@lizard.gateway.2wire.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-27 09:59 PM, Anton Vorontsov wrote:

[...]

> 
> I see. In that case, please feel free to send the patch to akpm with my
> Nack and pointing to this discussion. If Andrew agrees and I was wrong
> (and I'm really curious whether I am right or wrong), I will start
> applying such patches in future.

Hi Anton,

I didn't send the patch to akpm, but I did have a chance to ask akpm how
dependencies should be used, and you can see his answer here:

	https://lkml.org/lkml/2013/3/7/456

Paul.
--

> 
> Thanks,
> 
> Anton
> 
