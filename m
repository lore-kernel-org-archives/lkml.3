Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaG2JZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:25:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaG2JZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:25:45 -0400
Date: Tue, 29 Jul 2014 11:25:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ao2@ao2.it>
cc: Jamie Lentin <jm@lentin.co.uk>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] HID: lenovo: Add support for Lenovo Compact
 Keyboard
In-Reply-To: <20140725160527.13cbeae1108fce5e09b6daae@ao2.it>
Message-ID: <alpine.LNX.2.00.1407291125220.16390@pobox.suse.cz>
References: <1406154648-14000-1-git-send-email-jm@lentin.co.uk> <20140725160527.13cbeae1108fce5e09b6daae@ao2.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Antonio Ospite wrote:

> > This patchset follows on from my previous attempts to add support for
> > these keyboards from Lenovo.
> > 
> > Antonio, I've used cptkbd_data and left data_pointer for now. It'd be
> > an easy patch to change data_pointer to tpkbd_data, but is drifting
> > away from what this patchset is supposed to do. Could send that
> > afterwards though.
> 
> Sure, no problem. I think we are good to go.

I am queuing this patchset for 3.17, thanks everybody.

-- 
Jiri Kosina
SUSE Labs
