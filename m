Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab3CSVg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:36:28 -0400
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:59970 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3CSVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:36:26 -0400
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aul2AIrZSFFV5qjOPGdsb2JhbABDhzwjhQG4OAICAYFbFwMBAQEBODWCJAEBBAE6HCMFCwgDDhMlDwUlChouh3MKsg2QDBWNXlRHB4JfYQOTGYNFhg2MJYFcOw
X-IronPort-AV: E=Sophos;i="4.84,874,1355094000"; 
   d="scan'208";a="222222955"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 19 Mar 2013 22:40:57 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: multitouch: support of hybrid finger/pen devices
Message-ID: <20130319214057.GA7902@polaris.bitmath.org>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1303182313080.9529@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303182313080.9529@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Benjamin,

> > So the solution consists in relying inconditionaly to the quirk MULTI_INPUT for
> > hid-multitouch. Before registering the input device in hid-input, we can test if
> > it has been populated, and if not, then we simply don't register it. In order to
> > prevent a regression for drivers that do not fill the input device, we need to
> > add an other quirk.
> 
> Hi everybody,
> 
> I am in progress of reviewing this patchset, and so far don't have any 
> major obejctions; I expect to have the review finished this week, so 3.10 
> is definitely a realistic target.

I agree, I think it looks sound in general.

> Just to set my own expectations correctly -- Henrik, are you going to 
> review this patchset as well, or there is no need for me to wait for your 
> feedback?

No need to wait any longer ;-)

Cheers,
Henrik
