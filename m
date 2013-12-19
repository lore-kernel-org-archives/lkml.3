Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3LSQ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:29:00 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54275 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3LSQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:28:58 -0500
Message-ID: <52B31EC1.6050403@gmail.com>
Date: Thu, 19 Dec 2013 09:28:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        eranian@google.com, adrian.hunter@intel.com, mingo@redhat.com,
        paulus@samba.org, a.p.zijlstra@chello.nl,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 0/4] Add support of guest user space symbols for perf
 kvm command.
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com> <20131219141232.GM4819@ghostprotocols.net> <20131219153453.GA20044@gmail.com>
In-Reply-To: <20131219153453.GA20044@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13, 8:34 AM, Ingo Molnar wrote:

> Btw., having to specify a '--guestmount /tmp/guestmount/' just to
> achieve a natural feature (proper guest symbol resolution) is a poor
> user interface, obviously.
>
> Is there perhaps a predictable pattern as to where qemu (or libvirt)
> puts a user's guest mounts, or some other discovery method?

No, qemu does not export guest info to the host. A user has to create it 
-- either using something like sshfs or copying the files. I tend to use 
the latter as it is simpler.

David

>
> If yes then it would be possible to automatically look for that
> pattern, and use the guest filesystem when it's available, without the
> user having to manually configure the path.
>
> ( Ideally we'd have kernel help for discovering this, but last time I
>    raised that with the KVM folks there was resistence. )


