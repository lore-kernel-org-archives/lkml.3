Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682Ab3DIDhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:37:14 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37627 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3DIDhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <51638A27.3040607@redhat.com>
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org>
	<1365113821-22749-2-git-send-email-yinghai@kernel.org>
	<51626D3D.4000907@redhat.com>
	<CAE9FiQUsMGmF2PXMD2W+f7oYBJVudccxoWnisLEsDxXzGgoi0g@mail.gmail.com>
	<51638A27.3040607@redhat.com>
Date: Mon, 8 Apr 2013 20:37:12 -0700
X-Google-Sender-Auth: qBeXNeIhizLzupW2sFakO1M3P0g
Message-ID: <CAE9FiQXGtOtE3qdb6Ve7E9vkSUL1UwMWHK+4bgjRytQFqy=aDw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 8:25 PM, Dave Young <dyoung@redhat.com> wrote:

> I have another question, under x86_64 consider 1st kernel memory < 4G,
> is the swiotlb memory still necessary?

No. unless use swiotlb=force.

Thanks

Yinghai
