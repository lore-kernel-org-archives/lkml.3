Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270AbaGXX07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:26:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45016 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934961AbaGXX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <53D194F1.6020603@redhat.com>
References: <1406237179-3713-1-git-send-email-ast@plumgrid.com>
	<53D194F1.6020603@redhat.com>
Date: Thu, 24 Jul 2014 16:26:54 -0700
Message-ID: <CAMEtUuxHp5QzWQ+DhMPiNWDH6LxWPjgincK=Sk8xeJjivieY0w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: filter: rename 'struct sock_filter_int'
 into 'struct bpf_insn'
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 4:21 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 07/24/2014 11:26 PM, Alexei Starovoitov wrote:
>>
>> eBPF is used by socket filtering, seccomp and soon by tracing and
>> exposed to userspace, therefore 'sock_filter_int' name is not accurate.
>> Rename it to 'bpf_insn'
>>
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>> ---
>
> ...
>
>>   #define BPF_ALU64_REG(OP, DST, SRC)                           \
>> -       ((struct sock_filter_int) {                             \
>> +       ((struct bpf_insn) {                            \
>
>
>                              ^^^ Please also fix up whitespacing here
>                                  and all the other sections below.

you mean to align last \ with other lines?
sure. good point.
