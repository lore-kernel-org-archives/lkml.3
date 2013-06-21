Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423127Ab3FUG3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:29:35 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61944 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030533Ab3FUG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:29:33 -0400
Date: Thu, 20 Jun 2013 23:29:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Matthew Garrett <mjg@redhat.com>, Liu Jiang <liuj97@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
Message-ID: <20130621062929.GB11014@mtj.dyndns.org>
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com>
 <51BE6B5C.70803@intel.com>
 <20130617180151.GG32663@mtj.dyndns.org>
 <51C02571.3090100@intel.com>
 <51C26861.9050106@intel.com>
 <51C2E12F.4000603@cogentembedded.com>
 <51C3A489.1050905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C3A489.1050905@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 21, 2013 at 08:55:37AM +0800, Aaron Lu wrote:
> >     Please indent this line under the next character after ( above.
> 
> Is there a link about this rule? I might have missed something about
> coding style.

I don't think there's an explicit rule about that and I don't follow
it religiously but I think it does make things easier on the eyes and
emacs does that by default so I just got used to it.  It's a very
minor thing but FWIW I prefer things that way.

Thanks.

-- 
tejun
