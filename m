Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaH2NtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:49:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57971 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaH2NtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:49:24 -0400
Message-ID: <540084C7.4090300@gmail.com>
Date: Fri, 29 Aug 2014 07:48:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf kvm stat: unify print_vcpu_info() for report/live
References: <1409242664-10883-1-git-send-email-yarygin@linux.vnet.ibm.com>	<53FF69E3.2020501@gmail.com> <87vbpbsd1o.fsf@linux.vnet.ibm.com>
In-Reply-To: <87vbpbsd1o.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/14, 6:20 AM, Alexander Yarygin wrote:
> So, should I resend it with 2 patches?

It would be simpler that way. Change the pid handling first and then the 
title.

David
