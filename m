Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbaGANnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:43:07 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49849 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753191AbaGANnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:43:04 -0400
Date: Tue, 1 Jul 2014 14:42:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701134252.GQ32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk> <53B2B5E5.50502@gmail.com> <20140701133627.GP32514@n2100.arm.linux.org.uk> <53B2BA3E.1010705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B2BA3E.1010705@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:40:14PM +0200, Sebastian Hesselbarth wrote:
> On 07/01/2014 03:36 PM, Russell King - ARM Linux wrote:
>> On Tue, Jul 01, 2014 at 03:21:41PM +0200, Sebastian Hesselbarth wrote:
>>> On 07/01/2014 03:10 PM, Russell King - ARM Linux wrote:
>>>> On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
>>>> If you want to do this then you need to add the endpoints from the start
>>>> even though the driver doesn't yet make use of them - or don't add the
>>>> DT bits at all.
>>>
>>> If you really think that way, I definitely give up on mainline Dove and
>>> SolidRun Cubox. You are /really/ proposing to wait for *all* related
>>> subsystem bindings to settle before even starting to add DT support?
>>
>> *Sigh*.
>
> Russell,
>
> honestly, I am out. Feel free to take over anything you want. I
> understand you are in a bad mood because you feel ignored on your
> patches, but for me your attitude is unbearable and *the* reason
> to step back now.

That's fine, and probably for the best, since you appear not to be able
to take part in the completely reasonable technical discussion in this
thread.

I wish you all the best in your future endeavours.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
