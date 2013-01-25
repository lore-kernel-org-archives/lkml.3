Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3AYU7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:59:30 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:42768 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:59:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4_iz29b9Tj8W4D9YqdGPV4P+rFZ463eZ1S4J2gL_6qyw@mail.gmail.com>
References: <1356594177-29453-1-git-send-email-linfeng@cn.fujitsu.com>
	<CAErSpo7EmvDaK11P6r-PKxPBqHQBPaGvZj=zvNZ8w=KFbdFgYA@mail.gmail.com>
	<5102583E.4030109@cn.fujitsu.com>
	<CAErSpo58qUuwd+8bGMWQHQ6KrfQMvHGb+REVkpJqQdrfAQe3Qw@mail.gmail.com>
	<CAE9FiQUP71TJgP21SRre4Mb2PrnUg+7KLzXnxHUviqCuNSL44w@mail.gmail.com>
	<CAErSpo4_iz29b9Tj8W4D9YqdGPV4P+rFZ463eZ1S4J2gL_6qyw@mail.gmail.com>
Date: Fri, 25 Jan 2013 12:59:28 -0800
X-Google-Sender-Auth: vqzSEYVv5i9M0xoAZu89ih7G-Kc
Message-ID: <CAE9FiQVV20XktXTfQ2OKQeprL1V2rGORpUf8VBOyDB4Y+VOCNQ@mail.gmail.com>
Subject: Re: [PATCH] pci-sysfs: replace mutex_lock with mutex_trylock to avoid
 potential deadlock situation
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Lin Feng <linfeng@cn.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Don Dutile <ddutile@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:30 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> If we're going to fix the sysfs deadlock (and we should), I want to
> either see an argument for why we don't have a problem outside of
> sysfs, or I want to fix sysfs and non-sysfs at the same time.

Sure.

Jiang should have one patches to address that?

Yinghai
