Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbbAZUbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:31:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbbAZUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:31:09 -0500
Date: Mon, 26 Jan 2015 21:31:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jim Keir <jimkeir@oracledbadirect.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Fix force effect modifications for the Microsoft
 Sidewinder Force Feedback Pro 2 joystick
In-Reply-To: <0000014b1b51014e-a736e0b0-11f5-4a60-b857-4585e9e9106d-000000@email.amazonses.com>
Message-ID: <alpine.LNX.2.00.1501262130150.10817@pobox.suse.cz>
References: <1422033640-4104-1-git-send-email-jimkeir@oracledbadirect.com> <0000014b17cfde4d-df42e887-9524-4f07-a46b-5d81f01fc687-000000@email.amazonses.com> <CAN+gG=FHtsRzouBNY-YqXhH8SXKCc4Gw2TF6Z+_-+Cp_iPj6RA@mail.gmail.com>
 <0000014b1b51014e-a736e0b0-11f5-4a60-b857-4585e9e9106d-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015, Jim Keir wrote:

> Yes, confirmed. The description below still holds.

Could you please therefore fix this patch so that it contains proper 
changelog on proper place, and resubmit?

Also, the Subject line looks rather strange to me ... to my 
understanding, this isn't really specific for MS sidewinder hardware, 
right?

-- 
Jiri Kosina
SUSE Labs
