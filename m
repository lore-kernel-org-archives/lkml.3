Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbaKNNnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:43:19 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50543 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248AbaKNNnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:43:18 -0500
MIME-Version: 1.0
In-Reply-To: <1413772855-8613-1-git-send-email-sasha.levin@oracle.com>
References: <1413772855-8613-1-git-send-email-sasha.levin@oracle.com>
Date: Fri, 14 Nov 2014 17:43:17 +0400
Message-ID: <CAPAsAGwFzwqVW1y_A76q68uDAMFm-yWjTtJtXUprOWaEifS2uQ@mail.gmail.com>
Subject: Re: [PATCH v2] kernel: use the gnu89 standard explicitly
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
        kirill@shutemov.name, Alexander Viro <viro@zeniv.linux.org.uk>,
        pinskia@gmail.com, joe@perches.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-20 5:40 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
> gcc5 changes the default standard to c11, which makes kernel
> build unhappy.
>
> Explicitly define the kernel standard to be gnu89 which should
> keep everything working exactly like it was before gcc5.
>

Ping.
