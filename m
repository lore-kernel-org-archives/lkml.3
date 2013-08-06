Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3HFN2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:28:06 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:48128 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3HFN2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:28:04 -0400
Message-ID: <5200F9E2.3010007@gmail.com>
Date: Tue, 06 Aug 2013 09:28:02 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf kvm live - latest round take 4
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com> <52008D8F.6090905@linux.vnet.ibm.com>
In-Reply-To: <52008D8F.6090905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/13 1:45 AM, Xiao Guangrong wrote:
> On 08/06/2013 09:41 AM, David Ahern wrote:
>> Hi Arnaldo:
>>
>> This round addresses all of Xiao's comments. It also includes a small
>> change in the live mode introduction to improve ordered samples
>> processing. For that a change in perf-session functions is needed.
>
> Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>
> David, could you please update the documentation? It can be a separate
> patch.

Yes. I completely forgot. Take care of that later today.

David

