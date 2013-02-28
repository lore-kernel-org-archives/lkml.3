Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab3B1PTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:19:14 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60690 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3B1PTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:19:11 -0500
Message-ID: <512F756D.90101@gmail.com>
Date: Thu, 28 Feb 2013 08:19:09 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: Re: [PATCH] perf kvm: fix segfault by initializing file_name to NULL
References: <1362022197-38929-1-git-send-email-dsahern@gmail.com> <512EDD96.9090600@linux.vnet.ibm.com> <512EE073.8090709@gmail.com> <20130228142411.GE2656@ghostprotocols.net>
In-Reply-To: <20130228142411.GE2656@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/13 7:24 AM, Arnaldo Carvalho de Melo wrote:
> Just fast forwarded my perf/urgent to tip/perf/urgent, checked and the
> fix is there as pointed out by Xiao.

hmm.... hanging out in your perf/core branch rather than perf/urgent.

David
