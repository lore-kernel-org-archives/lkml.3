Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3FYHfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:35:15 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24007 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3FYHfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:35:13 -0400
X-Spam-Score: -100.8
Message-ID: <51C947FD.4000205@asianux.com>
Date: Tue, 25 Jun 2013 15:34:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Tony Breeds <tony@bakeyournoodle.com>, Mark Salter <msalter@redhat.com>,
        "a-jacquiot@ti.com" <a-jacquiot@ti.com>, jkc@redhat.com,
        linux-c6x-dev@linux-c6x.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: c6x: kernel: include "linux/console.h" when 'VT'
 and 'DUMMY_CONSOLE' enabled.
References: <51C8F948.2040204@asianux.com> <CAMuHMdXngNACn+Qfw1ytJkWWLm_BC+g_PTDpHHbUQyeeyVu8Fg@mail.gmail.com>
In-Reply-To: <CAMuHMdXngNACn+Qfw1ytJkWWLm_BC+g_PTDpHHbUQyeeyVu8Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 03:06 PM, Geert Uytterhoeven wrote:
> On Tue, Jun 25, 2013 at 3:58 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> > Need include "linux/console.h" when 'VT' and 'DUMMY_CONSOLE' enabled
>> > (e.g allmodconfig).
>> >
>> > The related error:
>> >   arch/c6x/kernel/setup.c: In function ‘setup_arch’:
>> >   arch/c6x/kernel/setup.c:442:2: error: ‘conswitchp’ undeclared (first use in this function)
>> >   arch/c6x/kernel/setup.c:442:2: note: each undeclared identifier is reported only once for each function it appears in
>> >   arch/c6x/kernel/setup.c:442:16: error: ‘dummy_con’ undeclared (first use in this function)
> Ah, so you managed to obtain a c6x toolchain. There's none at
> https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/ yet :-(

Hmm..., I use:
  [root@dhcp122 linux-next]# rpm -qf /usr/bin/c6x-linux-gnu-gcc
  gcc-c6x-linux-gnu-4.7.1-0.1.20120606.fc17.x86_64

When fix the 3 compiling issues, it almost can pass compiling: during
compiled to fs subsystem, I stopped compilation manually.


Thanks.
-- 
Chen Gang

Asianux Corporation
