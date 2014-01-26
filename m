Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaAZT56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 14:57:58 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:64480 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaAZT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 14:57:57 -0500
Message-ID: <52E568C2.5050001@gmail.com>
Date: Sun, 26 Jan 2014 20:57:54 +0100
From: Harald Arnesen <skogtun.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic with latest git kernel
References: <52E50496.3040303@gmail.com> <CAFLxGvx8OQzSzoikh9DT3VF=cdBw4=sU_ZM=BTs=M4Ts84eGgA@mail.gmail.com> <52E50ED7.9070808@gmail.com> <52E50F72.9060300@nod.at> <52E51FEE.4020403@gmail.com> <52E52300.7020008@nod.at>
In-Reply-To: <52E52300.7020008@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger [2014-01-26 16:00]:

> Your image shows that the kernel looses the init process because /init seems
> to be unable to exec switch_root.
> Find out what is going on in your initrd.
> 
> So far it has zero to do with the kernel itself.

Seems you are right. I just tried to compile a 3.13.0 kernel again
(which I did when i was released, and it worked then), and I got the
same panic.

Must be a Debian bug. I will pester them instead.
-- 
Hilsen Harald
