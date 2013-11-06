Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3KFCf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:35:29 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56085 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3KFCf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:35:28 -0500
Date: Tue, 5 Nov 2013 18:12:47 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Stuart Yoder <B08248@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kim.phillips@linaro.org" <kim.phillips@linaro.org>
Subject: Re: driver core patches
Message-ID: <20131106021247.GB6687@kroah.com>
References: <9F6FE96B71CF29479FF1CDC8046E15036F480C@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F6FE96B71CF29479FF1CDC8046E15036F480C@039-SN1MPN1-002.039d.mgd.msft.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:53:36PM +0000, Stuart Yoder wrote:
> Hi Greg,
> 
> Any feedback on the driver core patches in Kim Phillips patch series
> from mid-October?
> 
> The 3rd patch of the series has some open issues related to vfio-pci,
> but the first two are driver core related and am wondering if they
> are acceptable.

As I saw there was lots of discussion, and some rework needed, I haven't
paid any attention to them, expecting to see another set show up.

Also, it's way past the merge window, and I can't do anything with any
new patches until after 3.13-rc1 is out, combined with a
travel-schedule-from-hell, and I really am not going to want to review
these types of patches for a number of weeks.

So take the time, fix them up, and send them after 3.13-rc2 is out or so
and I should have a chance to look at them then.  Hopefully I'll hate
them less by then, but I'm not guaranteeing anything...

thanks,

greg k-h
