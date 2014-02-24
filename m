Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBXQ57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:57:59 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53101 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaBXQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:57:58 -0500
Message-ID: <530B7A13.3030907@mvista.com>
Date: Mon, 24 Feb 2014 10:57:55 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, minyard@acm.org
CC: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] ipmi: Turn off default probing of interfaces
References: <1393208616-16500-1-git-send-email-minyard@acm.org> <1393208616-16500-2-git-send-email-minyard@acm.org> <20140224165320.GA26479@core.coreip.homeip.net>
In-Reply-To: <20140224165320.GA26479@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 10:53 AM, Dmitry Torokhov wrote:
> Hi Corey,
>
> On Sun, Feb 23, 2014 at 08:23:34PM -0600, minyard@acm.org wrote:
> Would not
>
> static bool          si_trydefaults = IS_ENABLED(CONFIG_IPMI_SI_PROBE_DEFAULTS);
>
> work better here?
>
> Thanks.
>
Certainly.  I will update it.  Thanks,

-corey
