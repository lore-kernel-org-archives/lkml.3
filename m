Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbbAVJnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:43:14 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:59151 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbbAVJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:43:09 -0500
Message-ID: <54C0C628.2050107@nexus-software.ie>
Date: Thu, 22 Jan 2015 09:43:04 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        boon.leong.ong@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>	<1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>	<CAHp75VfNzXo=gkOhjkEGn+bSqk2kr+hOD_5PNxq4CsLjOqtG=w@mail.gmail.com>	<54C05207.6010306@nexus-software.ie> <CAHp75Vcd8axwSETRG8eq9Tu7Z0aPTDKfQr__gMsczt1PQ75sdg@mail.gmail.com>
In-Reply-To: <CAHp75Vcd8axwSETRG8eq9Tu7Z0aPTDKfQr__gMsczt1PQ75sdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 08:59, Andy Shevchenko wrote:

>> It was size >> 10 for V1 and you called it out as a magic number :)
>>
>> IMO, size / 1024 requires less thought to understand when reading the code.
>
> Oh, my bad. Now a bit modified suggestion, to add KiB inside format
> string and leave  / 1024. Would it work for you?

Sure thing. Makes sense to me.

--
BOD


