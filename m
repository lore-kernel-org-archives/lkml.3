Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaIJNb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:31:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaIJNbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:31:55 -0400
Message-ID: <541052A1.9010700@redhat.com>
Date: Wed, 10 Sep 2014 15:31:13 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Markos Chandras <Markos.Chandras@imgtec.com>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: filter: Add MIPS to architectures with
 BPF JIT
References: <1409322218-3689-1-git-send-email-markos.chandras@imgtec.com> <54009D34.3010800@redhat.com> <541050D0.1020302@imgtec.com>
In-Reply-To: <541050D0.1020302@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 03:23 PM, Markos Chandras wrote:
> On 08/29/2014 04:33 PM, Daniel Borkmann wrote:
>> On 08/29/2014 04:23 PM, Markos Chandras wrote:
>>> MIPS supports BPF JIT since v3.16-rc1
>>>
>>> Cc: Randy Dunlap <rdunlap@infradead.org>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Daniel Borkmann <dborkman@redhat.com>
>>> Cc: Alexei Starovoitov <ast@plumgrid.com>
>>> Cc: linux-doc@vger.kernel.org
>>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>>
>> Acked-by: Daniel Borkmann <dborkman@redhat.com>
...
> I think this hasn't been merged yet (I can't see it in mainline or
> linux-next). Do I need to ping someone or does it have to go via the
> MIPS tree?

You need to send this patch to netdev@vger.kernel.org so Dave
can pick it up from there.
