Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaIGN7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 09:59:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37302 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbaIGN7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 09:59:04 -0400
X-Sasl-enc: uCzNybXYQPRgouptBFkxgq6syYRoHg70G8Qd3Qo4FUle 1410098343
Date: Sun, 7 Sep 2014 10:58:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, akpm@linuxfoundation.org, arnd@arndb.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net,
        konrad.wilk@oracle.com
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
Message-ID: <20140907135850.GA23026@khazad-dum.debian.net>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
 <20140904201123.GA9116@khazad-dum.debian.net>
 <1409862708.28990.141.camel@misato.fc.hp.com>
 <1409873255.28990.158.camel@misato.fc.hp.com>
 <20140905102347.GA30096@gmail.com>
 <1409925023.28990.176.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409925023.28990.176.camel@misato.fc.hp.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2014, Toshi Kani wrote:
> On Fri, 2014-09-05 at 12:23 +0200, Ingo Molnar wrote:
> > Any reason why we have to create such a sharp boundary, instead 
> > of simply saying: 'disable PAT on all x86 CPU families that have 
> > at least one buggy model'?
> > 
> > That would nicely sort out all the broken CPUs, and would make it 
> > highly unlikely that we'd accidentally forget about a model or 
> > two.
> 
> Agreed.  I will disable this feature on all Pentium 4 models as well.  I
> do not think there is any necessity to enable it on Pentium 4.

Thank you.  That takes care of my misguivings about enabling this on aging
platforms as well.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
