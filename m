Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763640Ab3DDHsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:48:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763420Ab3DDHsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:48:40 -0400
Date: Thu, 4 Apr 2013 09:48:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: daniel.leung@linux.intel.com, srinivas.pandruvada@intel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-sensor-hub: do not process feature reports in
 raw_event
In-Reply-To: <alpine.LNX.2.00.1303271608500.23442@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1304040948280.30938@pobox.suse.cz>
References: <1363886546-6517-1-git-send-email-daniel.leung@linux.intel.com> <51507136.4020308@linux.intel.com> <alpine.LNX.2.00.1303271608500.23442@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Jiri Kosina wrote:

> > I am looking at 3.9.rc1.
> > The only place I see the raw_event callback is called from
> > hid/hid_input_report(). hid_input_report is called with type HID_INPUT_REPORT
> > in all cases, except hid_ctrl(), where it can be different depending on
> > xx.report->type. But here, the return value is not checked.
> > 
> > Do you know the call chain for HID_FETURE_REPORT, where this is creating
> > problem?
> 
> This was exactly what I was wondering about when I have seen the initial 
> patch a few weeks ago.
> 
> Daniel, could you please elaborate? Is there a out-of-tree driver for Acer 
> Iconia W700?

Daniel ... ?

-- 
Jiri Kosina
SUSE Labs
