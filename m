Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab3IZNhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:37:19 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53788 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3IZNhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:37:14 -0400
Message-ID: <52443889.30906@gmail.com>
Date: Thu, 26 Sep 2013 07:37:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tools/perf: remove unused MANIFEST
References: <1380187480-7575-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1380187480-7575-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/13 3:24 AM, Ramkumar Ramachandra wrote:
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>   This file was last touched 7 months ago. A lot seems to have changed
>   since then. Time to get rid of it?

No. That file is used to generate a tarfile for compiling perf outside 
of the kernel tree. See 'make help | grep perf'

David

