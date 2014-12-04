Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaLDXt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:49:29 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34607 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaLDXt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:49:28 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:18e4:f2cc:a02b:2d5c]
In-Reply-To: <1417736899-115619-1-git-send-email-agraf@suse.de>
References: <1417736899-115619-1-git-send-email-agraf@suse.de>
Date: Thu, 4 Dec 2014 15:49:27 -0800
Message-ID: <CAOesGMgATgU6TnrGvr2OH+x7R750bQ7X02WGL5Sqc1F2vhvZHA@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: Enable CONFIG_COMPAT also for 64k page size
From: Olof Johansson <olof@lixom.net>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 3:48 PM, Alexander Graf <agraf@suse.de> wrote:
> With binutils 2.25 the default alignment for 32bit arm sections changed to
> have everything 64k aligned. Armv7 binaries built with this binutils version
> run successfully on an arm64 system.
>
> Since effectively there is now the chance to run armv7 code on arm64 even
> with 64k page size, it doesn't make sense to block people from enabling
> CONFIG_COMPAT on those configurations.
>
> Signed-off-by: Alexander Graf <agraf@suse.de>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
