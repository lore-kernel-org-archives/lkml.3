Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaK3Tyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:54:47 -0500
Received: from syn.loicp.eu ([176.31.96.212]:39275 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaK3Typ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:54:45 -0500
Date: Sun, 30 Nov 2014 20:54:40 +0100
From: =?utf-8?B?TG/Dr2M=?= Pefferkorn <loic@loicp.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, gdonald@gmail.com,
        keith.mannthey@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warnings related to lock
 context imbalance
Message-ID: <20141130195439.GA12032@iron>
References: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
 <20141126205443.GB10615@kroah.com>
 <20141127183410.GA4582@iron>
 <20141128222207.GC27558@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141128222207.GC27558@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 02:22:07PM -0800, Greg KH wrote:
> 
> That's even worse than I imagined.  Putting sparse markings on these
> function calls is just papering over nonsense.  Please work on unwinding
> the mess so that you don't need callbacks for locks, that is an
> abstraction that isn't needed.
> 
> Same here, ick ick ick.
> 
> 
> Don't hide "implementation of locks" in functions like this, it only
> causes problems.  This code has layers of layers of layers of
> abstractions due to it wanting to be originally ported to other
> operating systems and lots of different kernel versions of Linux itself.
> Unwinding and removing those layers is a good thing to do, don't paper
> over the nonsense by putting sparse markings on pointless functions.
> 
> thanks,

Hi guys,

Thanks for your reply. I'm going to write a v2.

-- 
Cheers,
Loïc
