Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaBCPmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:42:52 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37390 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBCPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:42:51 -0500
Message-ID: <52EFB8F4.6010207@hitachi.com>
Date: Tue, 04 Feb 2014 00:42:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, hskinnemoen@gmail.com,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        egtvedt@samfundet.no,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] kernel/kprobes.c: move cleanup_rp_inst() to where CONFIG_KRETPROBES
 enabled
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com>
In-Reply-To: <52EF8222.6030709@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/03 20:48), Chen Gang wrote:
> On 02/02/2014 10:40 AM, Masami Hiramatsu wrote:
>> (2014/02/01 21:17), Chen Gang wrote:
>>> When CONFIG_KRETPROBES disabled, cleanup_rp_inst() is useless too. It
>>> is only called by unregister_kretprobes() which is in CONFIG_KRETPROBES
>>> enabled area.
>>>
>>> The related warning (allmodconfig under avr32):
>>>
>>>   kernel/kprobes.c:1181: warning: 'cleanup_rp_inst' defined but not used
>>
>> This patch itself looks good to me.
>> And it seems that not only the cleanup_rp_inst, but also other
>> kretprobe related functions should be moved (free_rp_inst,etc)
>>
> 
> OK, thanks, need/should I check them again and send patch v2 for them?

Yes, I'm happy to review it :)

Thank you!

> 
> 
> Thanks.
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


