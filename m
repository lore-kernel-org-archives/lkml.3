Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3FFPAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:00:45 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36048 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab3FFPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:00:44 -0400
Date: Thu, 6 Jun 2013 16:00:39 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Russ Anderson <rja@sgi.com>
Cc: joeyli <jlee@suse.com>, Matthew Garrett <matthew.garrett@nebula.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Message-ID: <20130606150039.GL30420@console-pimps.org>
References: <1370277079.6315.14.camel@x230.lan>
 <1370316933.30695.7.camel@linux-s257.site>
 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
 <1370444007.6315.32.camel@x230.lan>
 <20130605155904.GC30420@console-pimps.org>
 <1370495110.6523.35.camel@linux-s257.site>
 <1370497321.6315.44.camel@x230.lan>
 <1370504426.6523.49.camel@linux-s257.site>
 <20130606092542.GE30420@console-pimps.org>
 <20130606144846.GA10393@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606144846.GA10393@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun, at 09:48:46AM, Russ Anderson wrote:
> This looks like it will try to allocate more than the remaining size.
> Is that intended?

Yes, the intention is to trigger garbage collection.

-- 
Matt Fleming, Intel Open Source Technology Center
