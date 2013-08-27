Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3H0IC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:02:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3H0ICY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:02:24 -0400
Date: Tue, 27 Aug 2013 10:02:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] HID: Win 8 multitouch panels detection in core
In-Reply-To: <521BC4D7.5050507@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1308271002120.2077@pobox.suse.cz>
References: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com> <20130822175515.GA5215@polaris.bitmath.org> <alpine.LNX.2.00.1308261342430.2077@pobox.suse.cz> <521BC4D7.5050507@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013, Srinivas Pandruvada wrote:

> > > > Srinivas, I still did not added your tested-by as I made minors
> > > > modifications of
> > > > the patches 1 and 2. Now only the patch 1 will impact sensor_hub, and
> > > > patch 2
> > > > will not impact this. Maybe just wait for Henrik to put his
> > > > "Reviewed-by" before
> > > > giving one last test.
> > > Here goes:
> > > 
> > >      Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
> > Thanks guys. Not applying this just yet, waiting for Tested-by: from
> > Srinivas.
> > 
> Tested-by: Srinivas Pandruvada<srinivas.pandruvada@linux.intel.com>

Applied, thanks everybody.

-- 
Jiri Kosina
SUSE Labs
