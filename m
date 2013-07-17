Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3GQVcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:32:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3GQVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:32:52 -0400
Date: Wed, 17 Jul 2013 14:32:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-Id: <20130717143250.5de649f4a0fde9f1a52d73f6@linux-foundation.org>
In-Reply-To: <20130716172421.GA7982@redhat.com>
References: <1373991495-47411-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130716172421.GA7982@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 13:24:21 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:

> Michael, Hatayama, in case this series can't go in 3.11, do you have other
> ideas where a small hack fix will allow kdump to work on s390 and we
> don't have to revert the mmap() patches.

This would certainly be the preferred option at this stage.
