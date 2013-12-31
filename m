Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3LaKMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:12:09 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62962 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3LaKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:12:07 -0500
MIME-Version: 1.0
In-Reply-To: <52C2811C.4090907@huawei.com>
References: <52C2811C.4090907@huawei.com>
Date: Tue, 31 Dec 2013 11:12:04 +0100
Message-ID: <CAOMGZ=GOR_i9ixvHeHwfDN1wwwSQzFNFGa4qLZMhWWNzx0p8mw@mail.gmail.com>
Subject: Re: [PATCH] mm: add a new command-line kmemcheck value
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, wangnan0@huawei.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oops, resend to restore Cc.)

Hi,

On 31 December 2013 09:32, Xishi Qiu <qiuxishi@huawei.com> wrote:
> Add a new command-line kmemcheck value: kmemcheck=3 (disable the feature),
> this is the same effect as CONFIG_KMEMCHECK disabled.
> After doing this, we can enable/disable kmemcheck feature in one vmlinux.

Could you please explain what exactly the difference is between the
existing kmemcheck=0 parameter and the new kmemcheck=3?

Thanks,


Vegard
