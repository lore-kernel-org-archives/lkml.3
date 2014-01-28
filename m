Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaA1TwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:52:16 -0500
Received: from relaygw2-8.mclink.it ([213.21.178.155]:48490 "EHLO
	relaygw2-8.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaA1TwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:52:15 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2014 14:52:15 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkFAPkF6FJNK3Ai/2dsb2JhbABagwy/BBZ0giUBAQEDATo/BQsBCiElD0gZh30MAcoCF48cgw6BFAEDmCcBkh+DLjs
Date: Tue, 28 Jan 2014 20:37:10 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fmc: Fix decimal permissions
Message-ID: <20140128193710.GA5589@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1390934510.11756.14.camel@joe-AO722>
References: <1390934510.11756.14.camel@joe-AO722> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This 444 should have been octal.

Right, my fault. We are not using the sysfs interface for module
parameters, so I didn't notice.

> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Alessandro Rubini <rubini@gnudd.com>

thanks
/alessandro, with two other minor fmc fixes to submit soon
