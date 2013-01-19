Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3ASAkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:40:32 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33598 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3ASAk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
Date: Fri, 18 Jan 2013 17:40:26 -0700
Message-ID: <CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, alexander.deucher@amd.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 3:37 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan <shuahkhan@gmail.com> wrote:

>
> ok. I bisected the DMAR faults and it points to the following commit:
>
> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
>
> This commit as I recall, fixed the crash problem I was seeing back in
> 3.8-rc1. Reverting to see if crash problem reappears.

Confirming that with this commit reverted crash problem re-appeared.
With this commit, DMAR faults show up.

-- Shuah
