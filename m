Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab3GPRIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:08:09 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933296Ab3GPRII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:08:08 -0400
Message-ID: <51E57DF3.90304@nod.at>
Date: Tue, 16 Jul 2013 19:08:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com> <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
In-Reply-To: <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.07.2013 19:06, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>> If you don't want devtmpfs, just disable it in your config.
> 
> I don't understand: is this not a good default?  Why is creating bogus
> devices, confusing systemd, and making um Linux hard to boot
> desirable?
> 

Why does this confuse systemd? systemd has also a dependency on devtmpfs.

Thanks,
//richard
