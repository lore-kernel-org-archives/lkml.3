Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3GDWVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 18:21:51 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60642 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab3GDWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 18:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyOYi8oub0WRB9j0rHr-g3zyH8k_An=A5uQa+cugQnTNw@mail.gmail.com>
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com> <CAFLxGvyOYi8oub0WRB9j0rHr-g3zyH8k_An=A5uQa+cugQnTNw@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 5 Jul 2013 03:51:10 +0530
Message-ID: <CALkWK0kEw_03tp7M+JPKuqN4ytEtiDGa6iHKDcrXKHf2Wp6TJQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Get defconfig to work with ARCH=um
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger wrote:
>> [1/3] is somewhat unrelated to the series, and I happened to notice it
>> while reading.  12783aa07 (um: Switch to large mcmodel on x86_64,
>> 2012-01-24) indicates that I did something stupid, but I don't know
>> what.
>
> Yes, you broke kernel modules on um/x84_64.

Ah, thanks.  Kindly drop [1/3].

> Can you please merge 2/3 and 3/3?
> Make sure that a series is always bisect-able.

Oh, but it is bisect'able: [2/3] adds two unused files to configs:
i386_defconfig and x86_64_defconfig.  [3/3] removes the original
defconfig and teaches scripts to use the files added in [2/3].  I
split it for readable diffs, but I'll squash them if you prefer that.
