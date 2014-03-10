Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaCJRZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:25:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbaCJRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:25:39 -0400
Message-ID: <531DF57F.3040108@zytor.com>
Date: Mon, 10 Mar 2014 10:25:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xen.org,
        Sarah Newman <srn@prgmr.com>
Subject: Re: [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com> <531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com>
In-Reply-To: <531DF319.6010800@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:15 AM, David Vrabel wrote:
>>
>> And what the [Finnish] do you do if GFP_ATOMIC fails?
> 
> The same thing it used to do -- kill the task with SIGKILL.  I haven't
> changed this behaviour.
> 

No, you just made it many orders of magnitude more likely.

	-hpa

