Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3LTPCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:02:18 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42404 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3LTPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:02:17 -0500
Message-ID: <52B45BF6.1060701@gmail.com>
Date: Fri, 20 Dec 2013 08:02:14 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
CC: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com
Subject: Re: [PATCH 0/7 V2] Add support of user space symboles for guest.
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13, 1:52 PM, Dongsheng Yang wrote:
> Hi Arnaldo:
> 	Please help to review this patchset.
>
> Changelog:
> 	- v2:
> 		* splite the first commit.
>

At best you are creating knowledge of running tasks in the VMs when the 
perf session is started. That's it. That information cannot be used 
since the host has no idea what task is running in a VM at any given 
moment. No insight into process creation, mmaps, exits, etc.

David

