Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3LEO17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:27:59 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51630 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3LEO15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:27:57 -0500
Message-ID: <52A08D68.5020701@gmail.com>
Date: Thu, 05 Dec 2013 07:27:52 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf trace: Fix crash on RHEL6
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com> <1386211302-31303-3-git-send-email-dsahern@gmail.com> <20131205130924.GA10333@ghostprotocols.net>
In-Reply-To: <20131205130924.GA10333@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/13, 6:09 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 04, 2013 at 07:41:40PM -0700, David Ahern escreveu:
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>
> What would make no fields to be present if tp_format is not NULL, i.e.
> if the /format file was successfully parsed?

Sometimes it is not successfully parsed. I see failed to parse messages, 
so most likely the root cause. I was posting this one and the first one 
hoping you could take a look at RHEL6 problems. I think it is mostly an 
old kernel thing.

David

