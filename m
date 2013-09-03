Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab3ICA3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:29:25 -0400
Received: from riotingpacifist.net ([50.56.217.244]:58883 "EHLO
	riotingpacifist.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3ICA3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:29:24 -0400
From: Juan Barry Manuel Canham <Linux@riotingpacifist.net>
Cc: linux-kernel@vger.kernel.org
Subject: RE: linux 3.11
Date: Tue, 03 Sep 2013 01:29:21 +0100
Message-ID: <2051964.HH5T0WZGqy@jcanhamlaptop>
User-Agent: KMail/4.11 (Linux/3.5.0-30-generic; KDE/4.11.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that linux-iscsi.org isn't doing much to protect itself from being 
used as a spam source. If you setup the following you should be less likely to 
be marked as spam:

* SPF record (setup both spf and a txt spf record for compatibility) 
* DMARC record to enforce SPF and allow servers to contact you when linux-
iscsi.org is used as a spam source
* DKIM - more work and probably not needed, but I suspect having valid dkim 
signatures will help with some mail servers spam rankings 

Apologies as this isn't really Linux kernel related stuff but it might help 
other developers avoid being spammed by gmail too.
