Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaFRVKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:10:48 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:56077 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaFRVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:10:47 -0400
Date: Thu, 19 Jun 2014 00:10:39 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140618211038.GD558@drone.musicnaut.iki.fi>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com>
 <201406182122.29623@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201406182122.29623@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 18, 2014 at 09:22:29PM +0200, Pali Rohár wrote:
> So without this patch DT migration for Nokia N900 cannot be done 
> without breaking userspace - which is not acceptable...

I guess the fact is that the Nokia N900 proprietary userspace has
never worked properly with the mainline kernel without severe patching,
so you cannot really talk about any regression. If you cannot fix
those programs, you could still probably emulate the old Nokia kernel's
/proc/cpuinfo by providing some text file and bind mounting it, no?

A.
