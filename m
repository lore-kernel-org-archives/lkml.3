Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3AOWEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:04:39 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:60406 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3AOWEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:04:37 -0500
MIME-Version: 1.0
In-Reply-To: <2763397.yFrgeYvBXr@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQX6q-tbQuq_0mc0kBFC-bb0zKRDyg=aGLkrAeh5Y7FkYg@mail.gmail.com>
	<CAE9FiQWCg9ZF8mXF-fMKUhOXF=EDeS07BWKvUSDxWUxikrQu4w@mail.gmail.com>
	<2763397.yFrgeYvBXr@vostro.rjw.lan>
Date: Tue, 15 Jan 2013 14:04:34 -0800
X-Google-Sender-Auth: 68KqabagDDBjzA4uDDHJFj9_O3E
Message-ID: <CAE9FiQXS1kX=FS_2Fq_q7Nvcacr6xfQpKP0t12ndm-_chq+aEA@mail.gmail.com>
Subject: Re: [PATCH v8 08/22] PCI, acpiphp: Separate out hot-add support of
 pci host bridge
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 2:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Do I understand correctly that you're asking whether to merge the attached
> patches together, so as to obtain one combined patch?
>
> If so, yes, I'd like that to be done.

good, will merge them for easy review.

Thanks

Yinghai
