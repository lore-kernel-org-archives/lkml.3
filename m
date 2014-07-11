Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaGKTjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:39:01 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:44089 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071AbaGKTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:38:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1
X-HE-Tag: line66_4dc3316d71335
X-Filterd-Recvd-Size: 2532
Message-ID: <1405107531.2796.21.camel@joe-AO725>
Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's
 GPUs
From: Joe Perches <joe@perches.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "Bridgman, John" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Date: Fri, 11 Jul 2014 12:38:51 -0700
In-Reply-To: <20140711192248.GP1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
	 <20140711170411.GJ1870@gmail.com>
	 <D89D60253BB73A4E8C62F9FD18A939CA01031B37@storexdag02.amd.com>
	 <20140711181053.GK1870@gmail.com>
	 <D89D60253BB73A4E8C62F9FD18A939CA01031C4E@storexdag02.amd.com>
	 <20140711185138.GN1870@gmail.com>
	 <D89D60253BB73A4E8C62F9FD18A939CA01031CAD@storexdag02.amd.com>
	 <20140711192248.GP1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 15:22 -0400, Jerome Glisse wrote:
> Just to be explicit, my point is that is you claim GPL in MODULE_LICENSE
> then this is a GPL licensed code, if you claim GPL with additional rights
> than this is dual licensed code. This is how i read and interpret this
> with additional rights. In all the case the radeon code is considered
> dual license ie GPL+BSD (at least this is how i consider that code).

This is pretty common:

MODULE_LICENSE("Dual BSD/GPL");

There are a couple hundred of them.


