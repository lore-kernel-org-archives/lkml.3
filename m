Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3BKUoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:44:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab3BKUoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:44:37 -0500
Date: Mon, 11 Feb 2013 15:44:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cpw@sgi.com" <cpw@sgi.com>
Subject: Re: [PATCH] kdump, oldmem: support mmap on /dev/oldmem
Message-ID: <20130211204414.GA24936@redhat.com>
References: <33710E6CAA200E4583255F4FB666C4E20AC36B01@G01JPEXMBYT03>
 <20130205151256.GB12853@redhat.com>
 <33710E6CAA200E4583255F4FB666C4E20AC61B3C@G01JPEXMBYT03>
 <20130207150623.GC6462@redhat.com>
 <33710E6CAA200E4583255F4FB666C4E20AC6735D@G01JPEXMBYT03>
 <33710E6CAA200E4583255F4FB666C4E20AC67384@G01JPEXMBYT03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33710E6CAA200E4583255F4FB666C4E20AC67384@G01JPEXMBYT03>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:33:49AM +0000, Hatayama, Daisuke wrote:

[..]
> Also, remap_pfn_range is the function exported into kernel modules, so changing the third argument means changing ABI. Introducing a kind of remap_pfn_range_64 is a good idea? if there's someone needing the feature on 32-bit kernel.

I thought kernel does not care about compatibility with out of tree
modules and any user of in-tree module is updated to use new API. I could
be wrong though...

Thanks
Vivek
