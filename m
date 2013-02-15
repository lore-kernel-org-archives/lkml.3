Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3BOQxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:53:31 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43368 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3BOQxa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 15 Feb 2013 11:53:30 -0500
Message-Id: <511E761402000078000BEDD8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 15 Feb 2013 16:53:24 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <roger.pau@citrix.com>, <jinsong.liu@intel.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Patches for v3.9 for the Linux kernel.
References: <20130215163451.GD13775@phenom.dumpdata.com>
In-Reply-To: <20130215163451.GD13775@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.02.13 at 17:34, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> I know that the PVH patches are not in the Xen tree. I am hoping that
> at least the hypercalls _are_ OK with everybody so we can continue on
> with this.

Please don't commit to anything that isn't in the hypervisor tree
yet. IOW I'd like you to not push the PVH bits that use
uncommitted hypervisor interfaces (anything preparatory of
course is okay).

Jan

