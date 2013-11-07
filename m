Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3KGP7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:59:48 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53908 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KGP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:59:46 -0500
Message-ID: <527BB8EF.6050704@gmail.com>
Date: Thu, 07 Nov 2013 08:59:43 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH 0/4] perf record: Cleanups and mmap-based output
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com> <20131107132118.GD1251@krava.brq.redhat.com>
In-Reply-To: <20131107132118.GD1251@krava.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/13, 6:21 AM, Jiri Olsa wrote:
>
>    CC       builtin-record.o
> builtin-record.c: In function ‘do_mmap_output’:
> builtin-record.c:118:13: error: ignoring return value of ‘ftruncate’, declared with attribute warn_unused_result [-Werror=unused-result]
>      ftruncate(file->fd, offset);
>               ^
> cc1: all warnings being treated as errors
>

oops, fixed that and forgot to fold into the patch. Will take care of it 
on next round.

David

