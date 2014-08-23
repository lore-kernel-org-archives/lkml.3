Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaHWEta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 00:49:30 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47600 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaHWEt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 00:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <1408715952-19573-1-git-send-email-harald@redhat.com>
References: <1408715952-19573-1-git-send-email-harald@redhat.com>
Date: Fri, 22 Aug 2014 21:49:28 -0700
X-Google-Sender-Auth: ZBA88r3Qq_KtKtnk580e61BqOfY
Message-ID: <CAE9FiQXM=iw8vth6xiGNkUDJ0WYBXfVxtPFr8XjZSU+PVeDPdw@mail.gmail.com>
Subject: Re: [PATCH] early microcode: extend the ramdisk address to 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: harald@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 6:59 AM,  <harald@redhat.com> wrote:
> From: Harald Hoyer <harald@redhat.com>
>
> commit 4bf7111f50167133a71c23530ca852a41355e739 enabled loading of the
> initramfs above 4G addresses. So I was wondering, if the early microcode
> code might want to honor the upper 32bit of the 64bit address.
>

https://lkml.org/lkml/2014/6/11/27
