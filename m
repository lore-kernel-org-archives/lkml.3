Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab3BELOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:14:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab3BELOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:14:07 -0500
Date: Tue, 5 Feb 2013 12:13:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Support of Nexio 42" and new default class for
 hid-multitouch
In-Reply-To: <20130204115443.GA4405@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1302051212550.2260@pobox.suse.cz>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com> <20130203130731.GA2677@polaris.bitmath.org> <CAN+gG=GRS+fx4c3Kdba-89+ba8soimMm_rv7HDuaZLZWseQGuQ@mail.gmail.com> <20130204115443.GA4405@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Henrik Rydberg wrote:

> > Thanks for the review. However, before sending a new patch series, I'd
> > like to have your answers to my comments as I mostly disagree on
> > everything :)
> 
> With good reason, apparently. :-) I see no major problem with your
> patches, although the discussed details show that there is room for
> some refactoring.

Thanks to both of you. As I don't object to the HID core change, I have 
now applied the patchset, so please send any further additions on top of 
for-3.9/multitouch branch of my tree.

Also, Benjamin, perhaps it'd make sense to put a link somewhere into 
in-tree documentation, with pointer to your testing suite?

Thanks,

-- 
Jiri Kosina
SUSE Labs
