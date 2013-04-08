Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495Ab3DHSkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:40:14 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:54023 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935073Ab3DHSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
Date: Mon, 8 Apr 2013 11:40:11 -0700
X-Google-Sender-Auth: o3ye2MsoLM-sV32U3LAoIKstL8k
Message-ID: <CAE9FiQVaByGOTjLVthRkEze_ekXm5LAKgKdHzrD+q1iYmjgZFQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm: vmemmap: add vmemmap_verify check for hot-add
 node/memory case
From: Yinghai Lu <yinghai@kernel.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com,
        Arnd Bergmann <arnd@arndb.de>, tony@atomide.com,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 2:56 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
> In hot add node(memory) case, vmemmap pages are always allocated from other
> node,

that is broken, and should be fixed.
vmemmap should be on local node even for hot add node.

Thanks

Yinghai
