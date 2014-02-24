Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaBXQx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:53:28 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46171 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaBXQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:53:26 -0500
Date: Mon, 24 Feb 2014 08:53:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: minyard@acm.org
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 1/3] ipmi: Turn off default probing of interfaces
Message-ID: <20140224165320.GA26479@core.coreip.homeip.net>
References: <1393208616-16500-1-git-send-email-minyard@acm.org>
 <1393208616-16500-2-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393208616-16500-2-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey,

On Sun, Feb 23, 2014 at 08:23:34PM -0600, minyard@acm.org wrote:
Would not

static bool          si_trydefaults = IS_ENABLED(CONFIG_IPMI_SI_PROBE_DEFAULTS);

work better here?

Thanks.

-- 
Dmitry
