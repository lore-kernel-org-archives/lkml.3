Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbaFQK6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbaFQK6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:58:37 -0400
Message-ID: <53A01F3B.4050206@redhat.com>
Date: Tue, 17 Jun 2014 12:58:03 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Markos Chandras <Markos.Chandras@imgtec.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: mips:allmodconfig build failure in 3.16-rc1 due to bpf_jit code
References: <539FA6CB.5050703@roeck-us.net> <539FFA6B.9030004@redhat.com> <53A01572.5090603@redhat.com> <53A01E61.3090600@imgtec.com>
In-Reply-To: <53A01E61.3090600@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 12:54 PM, Markos Chandras wrote:
...
> This fixes the build and seems to work ok (tried with dhcp and tcpdump).
> Thanks for fixing it.
>
> Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>
> Tested-by: Markos Chandras <markos.chandras@imgtec.com>

Great, thanks for your help!
