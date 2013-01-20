Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3ATAVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 19:21:19 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53316 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3ATAVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 19:21:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzsb2C+qBXjCtSQcGYT6TGnRR8LuvsCAdcGvru7CvKkdA@mail.gmail.com>
References: <CAFLxGvyd032g4CYQfS8Woz+qZHvXAQa3s_cj7TOC=XVO1-HONw@mail.gmail.com>
	<CAE9FiQUQo2LOE=kmgQd_6A9YpkVzUZdS+MZYLzqg=SVc52LfUw@mail.gmail.com>
	<CAFLxGvzsb2C+qBXjCtSQcGYT6TGnRR8LuvsCAdcGvru7CvKkdA@mail.gmail.com>
Date: Sat, 19 Jan 2013 16:21:17 -0800
X-Google-Sender-Auth: u1ntyAJXoenTrOE1oJlKvJNFQt8
Message-ID: <CAE9FiQU_8D22DidY3m-HbHiRD4mEXVtcwBT4efRjWRCi2NZ5NQ@mail.gmail.com>
Subject: Re: Linux detects only 2.6GiB RAM in legacy boot
From: Yinghai Lu <yinghai@kernel.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 3:14 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:

> BTW: My BIOS is already the latest version.

[    0.000000] raw: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] raw: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] raw: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] raw: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] raw: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] raw: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] raw: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] raw: [mem 0x0000000040005000-0x000000008cfaafff] usable
[    0.000000] raw: [mem 0x000000008cfab000-0x00000000dae9efff] reserved
[    0.000000] raw: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] raw: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] raw: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
[    0.000000] raw: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] raw: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] raw: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] raw: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] raw: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] raw: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] raw: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] raw: [mem 0x0000000100000000-0x000000011e5fffff] usable

so really it is bios problem.

you can request one BIOS update about it or just return it.

Yinghai
