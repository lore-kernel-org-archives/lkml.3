Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3I3JWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:22:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49872 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000Ab3I3JWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:22:12 -0400
Date: Mon, 30 Sep 2013 10:22:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linn Crosetto <linn@hp.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] x86: EFI stub support for large memory maps
Message-ID: <20130930092207.GN21381@console-pimps.org>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
 <1379901548-70954-1-git-send-email-linn@hp.com>
 <20130925125840.GK21381@console-pimps.org>
 <20130925224541.GT13098@oranje.fc.hp.com>
 <20130926113400.GM21381@console-pimps.org>
 <20130927234607.GA17867@oranje.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927234607.GA17867@oranje.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep, at 05:46:07PM, Linn Crosetto wrote:
> Given that we have already successfully called exit_boot_services, can
> we still make this call to free_pool?

Urgh, good point. The answer is "no, not really".

I'll add your change verbatim and push out the 'next' branch again.

-- 
Matt Fleming, Intel Open Source Technology Center
