Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3LIJuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:50:06 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44241 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3LIJuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:50:01 -0500
Message-ID: <52A59244.2000908@gmail.com>
Date: Mon, 09 Dec 2013 10:49:56 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 4/9] ARM: pxa: remove unused variable
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>	 <1386543229-1542-1-git-send-email-ynvich@gmail.com>	 <1386543229-1542-5-git-send-email-ynvich@gmail.com>	 <52A585D9.4000605@gmail.com> <1386582151.7152.113.camel@host5.omatika.ru>
In-Reply-To: <1386582151.7152.113.camel@host5.omatika.ru>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 10:42 AM, Sergei Ianovich wrote:
> On Mon, 2013-12-09 at 09:56 +0100, Daniel Mack wrote:
>> A similar patch was already merged by Haojian recently. You should
>> probably rebase your patch stack on top of his maintainer tree.
> 
> I've just come across the patch you mention in the arm mailing list.
> 
> Could you please provide a link to Haojian's official public repository?

According to MAINTAINERS, it's here:

  git://github.com/hzhuang1/linux.git

But it seems it hasn't seen an update recently. Haojian?

> If possible, a link link to your repository will also be very helpful.

  https://github.com/zonque/linux/tree/pxa-dma-v2


Daniel

