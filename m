Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaEOEPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:15:11 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33063 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOEPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140514203859.8c82aa3a.akpm@linux-foundation.org>
References: <c8b0a9a0b8d011a8b273cbb2de88d37190ed2751.1400111179.git.luto@amacapital.net>
	<CAJd=RBC1E9x-zU-zJbNP+zbPgb=nhi39TqrxqpcGdi=OR9duXg@mail.gmail.com>
	<20140514203859.8c82aa3a.akpm@linux-foundation.org>
Date: Thu, 15 May 2014 12:15:08 +0800
Message-ID: <CAJd=RBCc15D-thT8Fzw+5bb=1vYrjMh2JaDpDLYzd1kJosLd-w@mail.gmail.com>
Subject: Re: [PATCH v2 -next] x86,vdso: Fix an OOPS accessing the hpet mapping
 w/o an hpet
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:38 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> We could easily change the interface so that pages==NULL means "no
> pages" but that isn't the way it works at present.
>
Yeah, thanks /Hillf
