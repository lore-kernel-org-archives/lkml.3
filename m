Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3IZPOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:14:33 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60925 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3IZPOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:14:30 -0400
Message-ID: <52444F53.504@gmail.com>
Date: Thu, 26 Sep 2013 09:14:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tools/perf: remove non-existent entries in MANIFEST
References: <1380205304-32224-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1380205304-32224-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/13 8:21 AM, Ramkumar Ramachandra wrote:
> The MANIFEST file is used in the following Makefile targets:
>
>    $ make tar{,gz,bz2,xz}-src-pkg
>
> to generate an archive that can be used outside the kernel tree. It
> contains entries that are used for pathspec filtering 'git archive',
> which ultimately generates the archive. Remove the stale
> entries (non-existent paths) by running:
>
>    $ while read l; do file $l; done <tools/perf/MANIFEST | grep ERROR
>
> in the toplevel kernel tree.

Did you create a tarfile after this change, unpack it somewhere out of 
three and then verify perf builds?

David

