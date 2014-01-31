Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaAaRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:09:08 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52257 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbaAaRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:09:06 -0500
MIME-Version: 1.0
Reply-To: for.poige+linux@gmail.com
In-Reply-To: <52EBD613.3040902@gmail.com>
References: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
 <CA+sTkh4p10P_BbxEx0vxS9uF0zA9G97K+4B_Q1Np55Ui83LVDQ@mail.gmail.com> <52EBD613.3040902@gmail.com>
From: Igor Podlesny <for.poige+linux@gmail.com>
Date: Sat, 1 Feb 2014 01:08:35 +0800
X-Google-Sender-Auth: aSPa8UGC6aNVkfKaPpDUVq8e5rA
Message-ID: <CA+sTkh6uR11zsgb7qRyBEwzn5f+s66dpM=JvvS8mYO8DwtG9-Q@mail.gmail.com>
Subject: Re: That greedy Linux VM cache
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
On 1 February 2014 00:57, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> If I remember correctly, there is a sysctl for configuring how
> aggressively the system tries to retain the VFS cache, changing the
> value there might improve things for you.

   Yeah, in theory. On practice I never saw a difference even with
vm.vfs_cache_pressure set to 800000.

-- 
End of message. Next message?
