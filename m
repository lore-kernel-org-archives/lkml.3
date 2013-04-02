Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab3DBMtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:49:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50412 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab3DBMtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:49:21 -0400
Message-ID: <515AD3CC.9040208@hitachi.com>
Date: Tue, 02 Apr 2013 21:49:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: oskar.andero@sonymobile.com
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Collett, Toby" <Toby.Collett@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH] kprobe: initialize kprobe_blacklist when it is
 used firstly
References: <1364799356-15768-1-git-send-email-iamjoonsoo.kim@lge.com> <515AB7C6.2030807@hitachi.com> <20130402121643.GA21724@caracas.corpusers.net>
In-Reply-To: <20130402121643.GA21724@caracas.corpusers.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/02 21:16), oskar.andero@sonymobile.com wrote:
> On 12:49 Tue 02 Apr     , Masami Hiramatsu wrote:
>> Hi,
>>
>> (2013/04/01 15:55), Joonsoo Kim wrote:
>>> Currently, initializing kprobe_blacklist is done during boot process.
>>> It takes 230 ms on our android platform and this is significant amount
>>> for our use case. We can disable CONFIG_KPROBES for production kernel,
>>> but it is hassle. This kprobe functionality is not commonly used,
>>> so we don't need to pay this cost at all times. With this rationale,
>>> change code to initialize kprobe_blacklist when it is used firstly.
>>
>> I saw similar patch from Oskar and Toby, and I decided to wait
>> until his blacklist separating work. I'd like to ask Oskar
>> how the patch is going first.
>>
> 
> I am currently preparing a series of 4 patches including the move of
> blacklist initialization (same as Joonsoo's patch) and separation of
> architecture specific blackpoints.
> The patches are dependent, so I appreciate if you wait a bit.
> 
> You can expect the series at latest tomorrow.

Thanks! I'd like to see such general solution :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


