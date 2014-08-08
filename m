Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaHHTu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:50:58 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47374 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaHHTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:50:54 -0400
Message-ID: <53E52A1C.8010504@gmail.com>
Date: Fri, 08 Aug 2014 13:50:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>, linux-kernel@vger.kernel.org
Subject: Re: perf on biarch
References: <20140808184049.65e7d32b@parrot.com>
In-Reply-To: <20140808184049.65e7d32b@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/14, 10:40 AM, Matthieu CASTET wrote:
> Hi,
>
> I have a 64 bits kernel running with 32 bits binaries.
> If I run 32 bits perf on this 64 bits kernel 3.14, I got weird result :
>
> - perf trace doesn't work [1]

I have patches that fix that:
     git clone https://github.com/dsahern/linux.git
     git checkout perf-full-monty

And if autodetection fails you can manually force it with -M x86.

David
