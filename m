Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaFFPWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:22:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaFFPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:22:48 -0400
Date: Fri, 6 Jun 2014 08:22:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tom Gundersen <teg@jklm.no>
Cc: Takashi Iwai <tiwai@suse.de>, Ming Lei <ming.lei@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Abhay Salunke <Abhay_Salunke@dell.com>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v2] firmware loader: allow disabling of udev as firmware
 loader
Message-ID: <20140606152240.GB13400@kroah.com>
References: <s5hfvjj1n90.wl%tiwai@suse.de>
 <CACVXFVP5CSNoyThAcsmihYg_bkq2wn1JtiFJ_7ehpxwjBSaZxQ@mail.gmail.com>
 <s5hbnu71mf1.wl%tiwai@suse.de>
 <CACVXFVPWq93u5KmLhr+g23t4AiGAnLfd+hX3viajzR_KN+sMrw@mail.gmail.com>
 <CAG-2HqXiFgy5M=k55iOYAdXezxsN-ZanWRWDgH-6fuU-uLawOQ@mail.gmail.com>
 <CACVXFVNKGPyv6AVUctotD=Sc97VRRGCXVzJ50pprjCNB7jhUxg@mail.gmail.com>
 <CAG-2HqWtbpKjkNTLAksGZSqskJRfjVOhGkJJFcJUNBFfajLhCg@mail.gmail.com>
 <CACVXFVOgr1y5KQxGDzvyPfqKHo0e3CsN+3HWo-_dxo6bmufbLQ@mail.gmail.com>
 <s5hegz2yw2s.wl%tiwai@suse.de>
 <CAG-2HqUe1oYJ8VBq1kP_Vy_smtkNjAWJ6_+TPu8c9-KVv6EOMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqUe1oYJ8VBq1kP_Vy_smtkNjAWJ6_+TPu8c9-KVv6EOMA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 04:15:03PM +0200, Tom Gundersen wrote:
> How about:
> 
> "If you rely on a customized udev (or other userspace tool) to load
> firmware from a non-standard path, say Y. Otherwise, say N. If your
> udev version does not support firmware loading (which is currently the
> upstream default), you must say N."

Like anyone ever reads help entries for config options...

"customized udev"?  What does that mean?

This is all bikeshedding, right?

greg k-h
