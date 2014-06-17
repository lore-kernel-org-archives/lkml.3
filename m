Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaFQLVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaFQLVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:21:46 -0400
Message-ID: <53A024A5.9040108@redhat.com>
Date: Tue, 17 Jun 2014 13:21:09 +0200
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
References: <539FA6CB.5050703@roeck-us.net> <539FFA6B.9030004@redhat.com> <53A01572.5090603@redhat.com> <53A01AED.4010008@roeck-us.net> <53A01ECA.6090504@redhat.com> <53A021E8.8020209@imgtec.com>
In-Reply-To: <53A021E8.8020209@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 01:09 PM, Markos Chandras wrote:
...
> Thanks for these instructions. I will try them myself once I find some
> time since I don't think bpf_jit for MIPS has ever been tested with all
> the opcodes.

Sounds great! If you find some tests are missing, please feel free to
submit them as well via netdev.

Best,

Daniel
