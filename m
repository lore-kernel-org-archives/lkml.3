Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBMXdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:33:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65491 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752852AbaBMXde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:33:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
Date: Fri, 14 Feb 2014 00:48:16 +0100
Message-ID: <2332416.4VqEbrnVLy@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140213171024.GA4420@srcf.ucam.org>
References: <8738jr5t3e.fsf@redhat.com> <87k3czdtbf.fsf@redhat.com> <20140213171024.GA4420@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 13, 2014 05:10:25 PM Matthew Garrett wrote:
> On Thu, Feb 13, 2014 at 09:40:36PM +0800, Madper Xie wrote:
> 
> > Thanks Matt. This patch fix the panic. And ioremap warning disappeared
> > after apply your patch.
> 
> The spec was originally unclear on what the valid bit meant - I think 
> this is the right thing to do.

Agreed.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
