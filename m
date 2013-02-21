Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3BUIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:09:56 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:40605 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3BUIJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:09:54 -0500
Date: Thu, 21 Feb 2013 12:09:50 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, u3557@dialix.com.au,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: prctl(PR_SET_MM)
Message-ID: <20130221080950.GF1740@moon>
References: <20130221080028.GE1740@moon>
 <20130221080358.7965659207B@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221080358.7965659207B@miso.sublimeip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 07:03:58PM +1100, Amnon Shiloh wrote:
> Hi,
> 
> Cyrill Gorcunov wrote:
> 
> > Wouldn't the below do the same trick but eliminate OR in preproc code?
> 
> Yes it would.  I don't mind having it either way.

OK, lets wait for opinions and see if this approach is acceptable.
