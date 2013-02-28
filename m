Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3B1Eb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:31:29 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37504 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3B1Eb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:31:28 -0500
Message-ID: <512EDD96.9090600@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 12:31:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: Re: [PATCH] perf kvm: fix segfault by initializing file_name to NULL
References: <1362022197-38929-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1362022197-38929-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022804-3864-0000-0000-00000704D055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/28/2013 11:29 AM, David Ahern wrote:
> Dongsoo reported that perf-kvm was segfaulting. The bug was introduced by
> commit 3786063 which moved file_name from struct perf_kvm which was
> initialized on the stack to an uninitialized stack variable. Fix by
> initializing.
> 
> Needs to be applied to 3.7 and 3.8 as well.

David, The bug has already been fixed by by Arnaldo, see:
http://git.kernel.org/?p=virt/kvm/kvm.git;a=commit;h=20914ce5b9e1ef4a35f1f09a2c9c8fb8eb1c4d86

