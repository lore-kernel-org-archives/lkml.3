Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaLMSQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 13:16:46 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:45748 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaLMSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 13:16:45 -0500
Message-ID: <548C828B.4040309@gmail.com>
Date: Sat, 13 Dec 2014 11:16:43 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: "perf top -g" leaking ~300MB per second.
References: <20141213084845.GA13453@x4> <20141213090331.GB13453@x4> <20141213152635.GG9845@kernel.org>
In-Reply-To: <20141213152635.GG9845@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/14 8:26 AM, Arnaldo Carvalho de Melo wrote:
> The callchain code was done initially for 'report' and when I made 'top'
> reuse the hist_entry code allowing 'top' to collect callchains was too
> easy, but then we need to go thru the callchain/hists/hist_entry code to
> make sure that they don't leak, will try to do it...
>

As I recall it is build up of the dead_threads list.

David

