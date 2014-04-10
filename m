Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbaDJN67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:58:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40396 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaDJN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:58:56 -0400
Message-ID: <5346A39A.3020304@hitachi.com>
Date: Thu, 10 Apr 2014 22:58:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops
References: <20140404185131.GA14738@redhat.com> <5343BCF0.3030605@hitachi.com> <20140408161020.GB31460@redhat.com> <5345440E.10800@hitachi.com> <20140409165516.GF18486@redhat.com>
In-Reply-To: <20140409165516.GF18486@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/10 1:55), Oleg Nesterov wrote:
> On 04/09, Masami Hiramatsu wrote:
>>
>> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thanks!
> 
> Does this mean that I can add the same into 6-8 you didn't ack
> explicitely ?

Ah, yes! You can add my reviewed-by to other patches in the series.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


