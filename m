Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaJAIRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:17:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaJAIRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:17:10 -0400
Date: Wed, 1 Oct 2014 10:17:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 00/13] HID: add support of Logitech touchpads and special
 devices
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1410011016160.26311@pobox.suse.cz>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Benjamin Tissoires wrote:

> Jiri, This patch series can be split in 2 if you would like:
> - patches 1 to 4 can be scheduled easily for 3.18 IMO
> - patches 5 to 13 might need some more reviews, so either 3.18 or 3.19

Benjamin,

thanks for the summary. I'll try to review 1-4 in time for 3.18, but I 
can't guarantee that.

Do you forsee any issues if the whole lot is queued for 3.19 only?

-- 
Jiri Kosina
SUSE Labs
