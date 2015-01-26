Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbbAZU23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:28:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbbAZU21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:28:27 -0500
Date: Mon, 26 Jan 2015 21:28:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Jim Keir <jimkeir@oracledbadirect.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fix initialisation for the Microsoft Sidewinder
 Force Feedback Pro 2 joystick
In-Reply-To: <CAN+gG=FC1gOCY1FQhHa16NALuyx2z5w7088k87O3eFM5518_Ug@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1501262127550.10817@pobox.suse.cz>
References: <0000014b17cfda93-ba54b0fb-23f4-4005-95c1-6ae695a48369-000000@email.amazonses.com> <CAN+gG=FC1gOCY1FQhHa16NALuyx2z5w7088k87O3eFM5518_Ug@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Benjamin Tissoires wrote:

> With the changes above (or if you fix my typos), the patch is
> Reviewed-by: Benjamin.tissoires <benjamin.tissoires@redhat.com>
> 
> Jiri, could you amend the commit with the above so that Jim won't be
> desperate by submitting a patch?

Done and applied this one. Jim, please make sure you fix your workflow for 
the next submission.

Thanks,

-- 
Jiri Kosina
SUSE Labs
