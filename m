Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3GPQAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:00:47 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932441Ab3GPQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:00:46 -0400
Message-ID: <51E56E2B.1000703@nod.at>
Date: Tue, 16 Jul 2013 18:00:43 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arch/um: make it work with defconfig and x86_64
References: <1372977930-4248-1-git-send-email-artagnon@gmail.com> <CALkWK0nME7EJUhTzD_1keAQVKBPkiGKoecmhPxFJV2Xu=zBAZQ@mail.gmail.com>
In-Reply-To: <CALkWK0nME7EJUhTzD_1keAQVKBPkiGKoecmhPxFJV2Xu=zBAZQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.07.2013 09:43, schrieb Ramkumar Ramachandra:
> Ping?
> 
> Does this patch look okay?

Yeah, patch looks ok. :)
It's queued up for 3.12.

I'm currently working on a patch series to remove SUBARCH completely.

Thanks,
//richard
