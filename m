Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaJIP01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:26:27 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51782 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbaJIP0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <87vbnt1js4.fsf@steelpick.2x.cz>
References: <87vbnt1js4.fsf@steelpick.2x.cz>
Date: Thu, 9 Oct 2014 08:26:18 -0700
Message-ID: <CAMEtUuzD00VW9KPh8XWu94QVRaG62M6D-w+c=CnzOcUu6+h35Q@mail.gmail.com>
Subject: Re: Linker error in function sys_bpf: undefined reference to `anon_inode_getfd'
From: Alexei Starovoitov <ast@plumgrid.com>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 5:59 AM, Michal Sojka <sojkam1@fel.cvut.cz> wrote:
> The error is:
>
>     kernel/built-in.o: In function `sys_bpf':
>     (.text+0x3b4fc): undefined reference to `anon_inode_getfd'

Thanks for the report. Working on a fix.
