Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFJMtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:49:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29903 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaFJMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:49:46 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-fc-5396fee708b2
Message-id: <5396FED1.2060802@samsung.com>
Date: Tue, 10 Jun 2014 15:49:21 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
 <1402404343.5350.1.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402404343.5350.1.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xa7rP/00LNni8VdfiXdNvFosvS+ss
	Drx7wmIxe9dDFovLu+awWXzoecRm8WnFJGYHdo+ds+6ye0w7sYzF48GhzSwe7/ddZfP4vEku
	gDWKyyYlNSezLLVI3y6BK2PJjkaWgq0sFf279jI1MO5j7mLk4JAQMJFYtl6qi5ETyBSTuHBv
	PVsXIxeHkMBSRollrbOZQBJCAo1MEq3XrSESsxglHv1qZwdJ8ApoSVxcuZQdZBCLgKrEpsfp
	IGE2AT2JDc0/wMKiAhESjy8IQVQLSvyYfI8FxBYR0JQ41vqREWQks8ByRokVS2+wgiSEBUIk
	jn2bzw6xdxOjxJUH4SA2p4CbxLIZHxhBbGYBdYlJ8xYxQ9jyEpvXvGWGqFeV6F67lg3iGUWJ
	05PPMU9gFJ6FZPcsJO2zkLQvYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESKV92MC4+
	ZnWIUYCDUYmHl0NnWrAQa2JZcWXuIUYJDmYlEd62v0Ah3pTEyqrUovz4otKc1OJDjEwcnFIN
	jHo8E+q/PGo+1GcjtPrDllWLbe88su57v3ezZuo6Ru5FRgfu/e2MdOPNbtqaev5uxObQE4+F
	3i1vvb1H2ofvos/6SSdW94e6zlqy3Xzi/0omoUqeNYUH/Rattf6YuiareAvrza3Gcfrmcv2e
	7gLrQs/vefa41GB7QvYRv9n/pwYd/vpNtK6c/aMSS3FGoqEWc1FxIgASK78KcgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 15:45, Mimi Zohar wrote:
> On Tue, 2014-06-10 at 11:48 +0300, Dmitry Kasatkin wrote: 
>> Hi Mimi,
>>
>> As you asked ofline , here is possible equivalent and simpler alternative
>> patches not requiring to have additional keyring.
> Please indicate which branch these patches apply to.
>
> thanks,
>
> Mimi
>
>

on the top of your tree #next-trusted-keys-experimental, excluding 1/4
patch, which is yours.
I included it by mistake because patches were on the top of that and I
used HEAD~3 instead of HEAD~2 to send them...

- Dmitry
