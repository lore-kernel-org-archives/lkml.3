Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaHTRFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:05:30 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:49843 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaHTRFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:05:24 -0400
Date: Wed, 20 Aug 2014 18:05:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: Loading initrd above 4G causes freeze on boot
Message-ID: <20140820170520.GF29733@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
 <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
 <20140813140219.GP15082@console-pimps.org>
 <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
 <20140813184449.GV15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813184449.GV15082@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug, at 07:44:49PM, Matt Fleming wrote:
> 
> At this point, I think modifying the max address is the best way to
> debug this further, and figure out what address causes the hang.

Mantas, did you manage to get to the bottom of this issue?

-- 
Matt Fleming, Intel Open Source Technology Center
