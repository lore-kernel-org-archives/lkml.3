Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaIKNf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:35:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45406 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaIKNfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:35:55 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1410442536.32328.1.camel@hadess.net>
Subject: [regression] Failed boot with 3.17rc0 on Baytrail tablet
From: Bastien Nocera <hadess@hadess.net>
To: linux-kernel@vger.kernel.org
Date: Thu, 11 Sep 2014 15:35:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5 (3.12.5-2.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Sorry about the wide distribution of this bug, but the mode of failure
makes it particularly hard to search for, be it in Bugzilla or search
engines. That's the failure:
https://bugzilla.kernel.org/attachment.cgi?id=149781

My Baytrail tablet, running a 32-bit UEFI, fails to boot with the
earliest 3.17 rc0 kernels and still with the newer 3.17 versions, though
3.16.0 worked as expected.

I believe that Adam Williamson had the same problem on his Dell Venue 8
Pro tablet.

I filed a bug here:
https://bugzilla.kernel.org/show_bug.cgi?id=84241
with a little more detail.

Any ideas about what could be wrong, or pointers to existing
discussions?

Cheers

