Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3CPJZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 05:25:45 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52124 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3CPJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 05:25:44 -0400
MIME-Version: 1.0
Date: Sat, 16 Mar 2013 17:25:43 +0800
Message-ID: <CAJd=RBDHwgtm=to3WUj73d7q6cjJ7oG6capjUxvcpVk0wH-fbQ@mail.gmail.com>
Subject: Re: OOM triggered with plenty of memory free
From: Hillf Danton <dhillf@gmail.com>
To: Jonathan Woithe <jwoithe@atrad.com.au>,
        David Rientjes <rientjes@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some system specifications:
> - CPU: i7 860 at 2.8 GHz
> - Mainboard: Advantech AIMB-780
> - RAM: 4 GB
> - Kernel: 2.6.35.11 SMP, 32 bit (kernel.org kernel, no patches applied)
>
The highmem no longer holds memory with 64-bit kernel.
