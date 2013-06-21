Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423250Ab3FUGsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:48:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:1699 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab3FUGr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,911,1363158000"; 
   d="scan'208";a="357232185"
Message-ID: <51C3F73D.3000603@intel.com>
Date: Fri, 21 Jun 2013 14:48:29 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Matthew Garrett <mjg@redhat.com>, Liu Jiang <liuj97@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org> <51C02571.3090100@intel.com> <51C26861.9050106@intel.com> <51C2E12F.4000603@cogentembedded.com> <51C3A489.1050905@intel.com> <20130621062929.GB11014@mtj.dyndns.org>
In-Reply-To: <20130621062929.GB11014@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 02:29 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jun 21, 2013 at 08:55:37AM +0800, Aaron Lu wrote:
>>>     Please indent this line under the next character after ( above.
>>
>> Is there a link about this rule? I might have missed something about
>> coding style.
> 
> I don't think there's an explicit rule about that and I don't follow
> it religiously but I think it does make things easier on the eyes and
> emacs does that by default so I just got used to it.  It's a very
> minor thing but FWIW I prefer things that way.

OK, will refresh the patch and send out again.

Thanks,
Aaron
