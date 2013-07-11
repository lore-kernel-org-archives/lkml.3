Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3GKHEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:04:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45414 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3GKHEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <1373526037-9134-1-git-send-email-gg.kaspersky@gmail.com>
References: <1373526037-9134-1-git-send-email-gg.kaspersky@gmail.com>
Date: Thu, 11 Jul 2013 10:04:33 +0300
X-Google-Sender-Auth: cyU9_pH_CpThEO7kR47PnRCzGcg
Message-ID: <CAOJsxLH3inzJ6xdfh9WdJ=Jx+DT32kbsVpd6r355O4QnWJu-fg@mail.gmail.com>
Subject: Re: [PATCH] madvise: fix checkpatch errors
From: Pekka Enberg <penberg@kernel.org>
To: Vladimir Cernov <gg.kaspersky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux@rasmusvillemoes.dk,
        shli@fusionio.com, Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 10:00 AM, Vladimir Cernov
<gg.kaspersky@gmail.com> wrote:
> This fixes following errors:
>         - ERROR: "(foo*)" should be "(foo *)"
>         - ERROR: "foo ** bar" should be "foo **bar"
>
> Signed-off-by: Vladimir Cernov <gg.kaspersky@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
