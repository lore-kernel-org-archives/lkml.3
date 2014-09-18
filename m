Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbaIRFKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:10:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53776 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaIRFKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:10:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140916094321.GA4610@distanz.ch>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
	<1410168160-3624-27-git-send-email-lftan@altera.com>
	<20140916094321.GA4610@distanz.ch>
Date: Thu, 18 Sep 2014 13:10:06 +0800
X-Google-Sender-Auth: tyP69pObkcz2NUn89RER4s2IxRY
Message-ID: <CAFiDJ58eFvdSLscTz6vb2QyVrPmh=Sk5ZPVG_uXa7=ziwkeS0g@mail.gmail.com>
Subject: Re: [PATCH v3 26/29] nios2: ptrace support
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 5:43 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
>
> This could be simplified to:
>
> long arch_ptrace(struct task_struct *child, long request, unsigned long addr,
>                  unsigned long data)
> {
>         return ptrace_request(child, request, addr, data);
> }
Okay, will change this.
