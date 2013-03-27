Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3C0Rv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:51:58 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39235 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3C0Rvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6DWfHii8d8rGPJ1dLj5TVzsgU7QGDoAvBM5Fb_N5=mtw@mail.gmail.com>
References: <CAE9FiQUrt11A0YAOLgvv3uTAWtTvVg3Mho9eD53orbxW6Jd8Vg@mail.gmail.com>
	<1363665251-14377-1-git-send-email-linfeng@cn.fujitsu.com>
	<CAErSpo6DWfHii8d8rGPJ1dLj5TVzsgU7QGDoAvBM5Fb_N5=mtw@mail.gmail.com>
Date: Wed, 27 Mar 2013 10:51:55 -0700
X-Google-Sender-Auth: 2CvidTQbiJrct26vebJl3acMdcA
Message-ID: <CAE9FiQU3z0jC5-_JLsc4i2yTnWxTv5V9WRThYD-Q5NrrnxvZuw@mail.gmail.com>
Subject: Re: [PATCH] kernel/range.c: subtract_range: fix the broken phrase
 issued by printk
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 10:27 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> So now the user might see:
>
>     subtract_range: run out of slot in ranges
>
> What is the user supposed to do when he sees that?  If he happens to
> mention it on LKML, what are we going to do about it?  If he attaches
> the complete dmesg log, is there enough information to do something?
>
> IMHO, that message is still totally useless.

Change to WARN_ONCE?

Yinghai
