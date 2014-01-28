Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaA1ROo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:14:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaA1ROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:14:41 -0500
Message-ID: <52E7E56D.9040302@oracle.com>
Date: Tue, 28 Jan 2014 12:14:21 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Geng Hui <hui.geng@huawei.com>
Subject: Re: [PATCH] Use realpath for srctree and objtree
References: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 05:06 AM, Wang Nan wrote:
> When BUILD_SRC contains a tailing '/', the file name used in compiling command
> will contain '//', and it then goes to .o's debuginfo, confuses debugedit:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=304121
>
> This patch uses realpath to makesure srctree and objtree don't have tailing '/'.
>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Geng Hui <hui.geng@huawei.com>
>
> ---

For the liblockdep changes:

	Acked-by: Sasha Levin <sasha.levin@oracle.com>
	

Thanks,
Sasha
