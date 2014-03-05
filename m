Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaCEJmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:42:21 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52116 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaCEJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:42:18 -0500
Date: Wed, 5 Mar 2014 10:42:10 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Alexey Perevalov <a.perevalov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
Message-ID: <20140305094210.GA6328@netboy>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
 <1392913425-29369-6-git-send-email-a.perevalov@samsung.com>
 <530D5715.1050901@mit.edu>
 <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de>
 <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
 <alpine.DEB.2.02.1403042254550.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403042254550.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:11:21PM +0100, Thomas Gleixner wrote:
> 
> Once we agree on a solution to the Y2038 issue on 32bit with a unified
> 32/64 bit syscall interface which simply gets rid of the timespec/val
> nonsense and takes a simple u64 nsec value we can add the slack
> property to that without any further inconvenience.

Can you expand on this tangent a bit?

Who needs to agree, and where is this being debated?

Thanks,
Richard
