Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbaDBQgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:36:54 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:45234 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaDBQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:36:49 -0400
Date: Wed, 2 Apr 2014 12:36:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Loc Ho <lho@apm.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH libata/for-3.15-fixes] libata: drop COMPILE_TEST from
 AHCI_XGENE
Message-ID: <20140402163645.GD16631@htj.dyndns.org>
References: <20140401184916.GA21938@kroah.com>
 <CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
 <20140402022858.GA4901@kroah.com>
 <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
 <533C0B45.4050909@ti.com>
 <CAPw-ZTn3_oEMFFNua1zoDibOBJOLC92k7zdc8Do+hk3Ai-BSaw@mail.gmail.com>
 <20140402155357.GA16631@htj.dyndns.org>
 <20140402162215.GC16631@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402162215.GC16631@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kishon.

I'm converting AHCI_XGENE to depend on PHY_XGENE instead of selecting
it as dependency chaining through select doesn't work.  Looking at the
PHY Kconfig options, I wonder whether we're going about this the right
way.  Are PHY drivers meaningful at all w/o higher level drivers
making use of them?  If not, why do we even have visible Kconfig opts
for them?  Shouldn't we just chain everything through selects and
float the actual dependencies to the higher level drivers which the
users actually care about?

Thanks.

-- 
tejun
