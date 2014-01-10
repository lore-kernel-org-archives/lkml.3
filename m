Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbaAJXMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:12:53 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:57325 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAJXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:12:49 -0500
MIME-Version: 1.0
In-Reply-To: <52D06C0C.9020300@canonical.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
	<52A8BAC5.70006@canonical.com>
	<CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
	<52D01D82.5070202@canonical.com>
	<CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
	<52D06C0C.9020300@canonical.com>
Date: Fri, 10 Jan 2014 15:12:48 -0800
X-Google-Sender-Auth: VXKBzn9Iy2KWlJwyL_zYTunsMCI
Message-ID: <CAE9FiQV39fmZ8DF9=SfjmvrdEnS+7pX+dj5q2x5e3m4pSBiaBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 1:54 PM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 01/10/2014 12:13 PM, Yinghai Lu wrote:
>
> In a prior email you mentioned: "Yes, if that works, we would not need
> to put the patch in upstream for limiting realloc auto scope."  Is the
> git tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> somehow different now?

but you boot with "pci=realloc=off", right?

Anyway please try pci/next to see if there is any help.

git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/next
