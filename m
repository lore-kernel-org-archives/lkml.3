Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3CCKUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 05:20:07 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55466 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab3CCKUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 05:20:05 -0500
Message-ID: <1362306002.1334.29.camel@x61.thuisdomein>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sun, 03 Mar 2013 11:20:02 +0100
In-Reply-To: <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk>
References: <20130301194351.913471337@linuxfoundation.org>
	 <20130301194355.578429064@linuxfoundation.org>
	 <1362172344.20156.15.camel@x61.thuisdomein>
	 <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
	 <1362263724.1334.18.camel@x61.thuisdomein>
	 <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2013 10:20:03.0803 (UTC) FILETIME=[AB9092B0:01CE17F8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 23:10 +0000, Ben Hutchings wrote:
> On Sat, 2013-03-02 at 23:35 +0100, Paul Bolle wrote:
> > 1) So if xen_vbd_translate() fails, it can return before setting
> > preq.dev. That makes the call of pr_debug() use an uninitialized value,
> > doesn't it?
> 
> Oh yes, so it's a completely valid warning in this case!

Thanks.

Perhaps Konrad, Jan, Or Ian can tell whether the patch still needs to go
in stable as is, because the problem it fixes is more severe than the
problem it apparently creates. Maybe a mainline fix is needed before
this can go in, or perhaps even a stable specific fix (if context
changes are to blame).


Paul Bolle

