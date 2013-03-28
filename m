Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3C1QyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:54:11 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61967 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab3C1QyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6u+7Ug_fh6+cHXUSpLV+MNtSn=6qBsMOhzmXqv+iWd4g@mail.gmail.com>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
	<1364444885-19751-2-git-send-email-yinghai@kernel.org>
	<CAErSpo7UYk5q2BPcS4xX06S3qwjK-XRw2LTgOUEiDqwNeAWNgQ@mail.gmail.com>
	<CAE9FiQVLXrxjvF7zFfcx96ey+QwxX=qJEXR=BGuTCZeANigz9A@mail.gmail.com>
	<CAErSpo6u+7Ug_fh6+cHXUSpLV+MNtSn=6qBsMOhzmXqv+iWd4g@mail.gmail.com>
Date: Thu, 28 Mar 2013 09:54:06 -0700
X-Google-Sender-Auth: 8oJEkLBN7aPQ6FuoY4m4psiOFNc
Message-ID: <CAE9FiQU7UZT7yiUQuaQop5f6dcO5i3U09Wv6KW8S5RMSqNDaVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] eisa, PCI: Fix bus res reference
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 9:14 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> So stable@kernel.org will never get fixed?
>
> What's to fix?  The doc (Documentation/stable_kernel_rules.txt) says
> to use "Cc: stable@vger.kernel.org" and using "Cc: stable@kernel.org"
> causes bounces.  Just use the documented address like everybody else
> and everything will be fine.

I don't think that I'm the only one is still using stable@kernel.org
in patch cc.
please check git log -p in recent commits in linus tree.

>
> If you want "stable@kernel.org" to work, first make the kernel.org
> change, then change Documentation/stable_kernel_rules.txt, *then*
> start using it in your patches.

stable@kernel.org is not restored after last kernel.org get breached.

And I thought stable@vger.kernel.org should be just temporary one.

Yinghai
