Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab3CESwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:52:55 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61990 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3CESwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:52:54 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <51363BAF.3010305@kernel.org>
References: <CA+icZUVhrWQn+mW8_HgApMgLBYvUD96XafMznP909tVJZS5TRg@mail.gmail.com>
	<51363BAF.3010305@kernel.org>
Date: Tue, 5 Mar 2013 19:52:52 +0100
Message-ID: <CA+icZUU=kAUWvrhoj0yPuDJhVXPC7baBm=JEctdDjpZTPNvodQ@mail.gmail.com>
Subject: Re: [www.k.o] Let tar.xz be the default tarball on the main-page?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 7:38 PM, Konstantin Ryabitsev <mricon@kernel.org> wrote:
> On 04/03/13 07:58 AM, Sedat Dilek wrote:
>> Hi,
>>
>> it is still tar.bz2 the default tarball for downloading.
>> As modern Linux-kernel versions exists also as tar.xz which is smaller
>> and causes less Internet traffic.
>> Save the planet :-)!
>
> I think I'll go ahead and do that, if only because some time down the
> line I'd like to stop making everything available as [.gz|.bz2|.xz] and
> eliminate bz2 altogether. Switching main page links to .xz will help me
> accomplish this goal in some distant future.
>

Yupp, tar.bz2 support should be dropped entirely.

- Sedat -

>
> Best,
> --
> Konstantin Ryabitsev
> Systems Administrator
> Linux Foundation, kernel.org
> Montréal, Québec
>
