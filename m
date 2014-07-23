Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaGWA5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:57:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56788 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaGWA5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:57:22 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-4a-53cf086cee61
From: Jingoo Han <jg1.han@samsung.com>
To: "'Suman Anna'" <s-anna@ti.com>
Cc: linux-kernel@vger.kernel.org, "'Tobias Klauser'" <tklauser@distanz.ch>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
 <53CE7C9C.6060107@ti.com>
In-reply-to: <53CE7C9C.6060107@ti.com>
Subject: Re: [PATCH] mailbox/omap: Use module_platform_driver
Date: Wed, 23 Jul 2014 09:57:16 +0900
Message-id: <002901cfa611$0c11c620$24355260$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+lvbrkEPQp7h/gTnqdz1STtacFgAAUthMQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zA90cjvPBBh++q1pcXniJ1eLyrjls
	Fnt/7WO1OHDgL6PF/iteDqwe375OYvG4cuo0u0ffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1
	SN8ugSvjyfLdrAVb2Sp2rlRtYJzJ2sXIySEhYCJxZ/NCKFtM4sK99WxdjFwcQgLLGCW6bk9m
	gSnauHYfI4gtJLCIUWLmJTsI+zejRN9lBxCbTUBN4suXw+wgtoiAgsSDN5cZQQYxC0xilPi7
	4xYbREO8xK9n18AGcQI1bFs8l7mLkYNDWMBW4s5dCZAwi4CqxNelW8H28gKFb2xpZ4WwBSV+
	TL4HFmcW0JJYv/M4E4QtL7F5zVuwMRIC6hKP/upCnGAksWZFMxtEiYjEvhfvwM6REDjHLrHy
	ShMTxC4BiW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckF
	xUnpRUZ6xYm5xaV56XrJ+bmbGCEx2reD8eYB60OMyUDrJzJLiSbnA2M8ryTe0NjMyMLUxNTY
	yNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwCgd6OTr/5p/S0SoUffFF
	8dTA6SwJ0zas6I7nYHt12orVTzvDYorskyuRX/9Pqm++mTDV4GSHl1HHkhuexxnqpkVYmot3
	Ty0sNxUs2qDz71nlmnyZ6Jsb2Dr/JjytPFj+0On2IT4Vx61XnT1uL4h9GRXHvDRsXcPXmAdT
	9pUkN2mZ73kqWXtAiaU4I9FQi7moOBEA7KB5nOcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG4Ox/lgg0drlSwuL7zEanF51xw2
	i72/9rFaHDjwl9Fi/xUvB1aPb18nsXhcOXWa3aNvyypGj+M3tjN5fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WT5btaCrWwVO1eqNjDOZO1i5OSQEDCR2Lh2
	HyOELSZx4d56NhBbSGARo8TMS3YQ9m9Gib7LDiA2m4CaxJcvh9lBbBEBBYkHby4D9XJxMAtM
	YpT4u+MWVHO8xK9n18CGcgI1bFs8l7mLkYNDWMBW4s5dCZAwi4CqxNelW1lAbF6g8I0t7awQ
	tqDEj8n3wOLMAloS63ceZ4Kw5SU2r3kLNkZCQF3i0V9diBOMJNasaGaDKBGR2PfiHeMERqFZ
	SCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnACeSe9gXNVgcYhR
	gINRiYe3oOZcsBBrYllxZe4hRgkOZiUR3uhWoBBvSmJlVWpRfnxRaU5q8SFGU6BHJzJLiSbn
	A5NTXkm8obGJmZGlkZmFkYm5uZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRotOnlWenZs4
	Zief//Eq4Mn1q5xM4vdsHrYc9Q/8ueWcSgnzvjoOmyO+//RY9x+xzt5nHKD0T89RT7TqeOkG
	t6/ml20dLC/61zdc5r6YwX87VsTRP2f9w79mLmvv61WG5U7bMbu8ITFM9a6m+MrcyWZP0jeK
	XOefcGyHDKvhtluv2088XmwwVYmlOCPRUIu5qDgRAPF9kFMWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 12:01 AM, Suman Anna wrote:
> On 07/22/2014 07:13 AM, Tobias Klauser wrote:
> > Use the module_platform_driver to omit module init/exit boilerplate code.
> >
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > ---
> >  drivers/mailbox/mailbox-omap1.c | 13 +------------
> >  drivers/mailbox/mailbox-omap2.c | 13 +------------
> >  2 files changed, 2 insertions(+), 24 deletions(-)
> 
> I have submitted a series that cleans up/consolidates the OMAP mailbox
> driver [1], and this patch won't be necessary as the same lines get deleted.

Oh, I see. So, this patch is unnecessary. I hope that Jassi's mailbox framework
is submitted soon. Thank you.

Best regards,
Jingoo Han

> 
> regards
> Suman
> 
> [1] http://www.spinics.net/lists/linux-omap/msg108574.html

