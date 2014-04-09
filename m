Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbaDIPQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:16:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895AbaDIPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:14:26 -0400
Date: Wed, 9 Apr 2014 17:14:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: do not stop the device at the end of probe
In-Reply-To: <1397055694-6312-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1404091713590.14588@pobox.suse.cz>
References: <1397055694-6312-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014, Benjamin Tissoires wrote:

> Well, this is embarrassing, if the device is stopped at the end of probe,
> we get into big troubles (it even oopses my kernel).
> 
> This was a leftover of an attempt to be smart when sending the patch,
> I deeply apologies.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> well, first thanks for having integrating hid-rmi in your for 3.16 branch.
> 
> While backporting it to 3.13 so Fedora can get it, I noticed a tiny difference
> (besides formatting) between the version I submitted and the one I asked people
> to test...
> 
> ...facepalm.

Well, I missed that as well when reviewing it. Good catch, now queued on 
top of previous one. Thanks,

-- 
Jiri Kosina
SUSE Labs
