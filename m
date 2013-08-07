Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3HGHoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:44:30 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:60485 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932125Ab3HGHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:44:27 -0400
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130806101421.GA29283@kroah.com>
Date: Wed, 7 Aug 2013 10:44:22 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Coussno?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <84B0EA3D-B6D7-4071-AEA6-019B771985B4@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com> <20130806093356.GA27889@kroah.com> <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com> <20130806101421.GA29283@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Aug 6, 2013, at 1:14 PM, Greg Kroah-Hartman wrote:

> On Tue, Aug 06, 2013 at 12:37:25PM +0300, Pantelis Antoniou wrote:
>>> I don't like this at all, sorry.
>>> 
>> 

[snip]

>> Don't shoot the messenger please...
>> 
>> This is all about fixing a crash without messing too many things.
> 
> I understand, it's not your fault at all.

Let's start talking about the patchset again.

I know all of this code is rather distasteful but it's only purpose
is to fix a bunch of crashes in a code path that was supposed to be working,
namely the removal of a platform device, in the supposedly well supported
ARM OMAP arch.

Can we agree to at least not crashing until we get to a consensus about
fixing the whole mess properly? This will take at least a few minor
kernel revisions while in the meantime users get crashes everyday.

Regards

-- Pantelis

