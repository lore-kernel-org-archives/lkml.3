Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaACJ4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:56:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaACJ4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:56:40 -0500
Date: Fri, 3 Jan 2014 10:56:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Edel Maks <edelmaks@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] HID: multitouch: add support of other generic
 collections in hid-mt
In-Reply-To: <52B5F96D.9050400@euromail.se>
Message-ID: <alpine.LNX.2.00.1401031056000.14951@pobox.suse.cz>
References: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com> <1387470191-9725-4-git-send-email-benjamin.tissoires@redhat.com> <52B5F96D.9050400@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013, Henrik Rydberg wrote:

> > The ANTEC Touch Pad is a device which can switch from a multitouch
> > touchpad to a mouse. It thus presents several generic collections which
> > are currently ignored by hid-multitouch. Enable them by using the generic
> > protocol. Adding also a suffix for them depending on their application.
> 
> In what way does this and the preceeding patches differ from "else if (is_pen ||
> export_all_inputs)"? Adding a functional pattern which then is converted to a
> generic case, such that the usual branching is bound to occur anyways, seems
> unnecessary.

Benjamin,

did you have chance to do any followup work on this?

If this is to go into 3.14, it's the time to have the thing finalized.

Thanks,

-- 
Jiri Kosina
SUSE Labs
