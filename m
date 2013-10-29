Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3J2Lyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:54:49 -0400
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:60953
	"EHLO know-smtprelay-omc-3.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3J2Lyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:54:47 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=LIo+2+q9 c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=jlPsK6Yxj2MA:10 a=IkcTkHD0fZMA:10 a=xq3W2uTSAAAA:8 a=N1CowNylAAAA:8
 a=7NqCWP14w4AA:10 a=wI_511deNenaNukEi98A:9 a=QEXdDO2ut3YA:10
 a=wTsYZljDQnEA:10 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1383051272.2598.55.camel@artifact>
Subject: Re: [PATCH] staging: Merge Crystal HD driver with linuxtv.org
From: Steven Newbury <steve@snewbury.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
        Manu Abraham <abraham.manu@gmail.com>
Date: Tue, 29 Oct 2013 12:54:32 +0000
In-Reply-To: <1382897718.2598.37.camel@artifact>
References: <1382891243.2598.10.camel@artifact>
	 <20131027155408.GA22705@kroah.com> <1382893938.2598.24.camel@artifact>
	 <20131027162613.GA23822@kroah.com> <1382897718.2598.37.camel@artifact>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
I'm making good progress.  My plan is to break/clean up the patch
logically:

patch1: Clean up debug/error messages  DONE - (this has actually
resulted in some bug fixes)

patch2: Remove commented out/unused code  TODO

patch3: Power management support  TODO

patch4: other misc fixes/changes (may be more than one patch) with
details in log message

patch5: Rename driver to crystalhd (instead of bcm70012) DONE

patch6: Restructure driver to prepare for BCM70015 support by splitting
out (BCM70012) hw specific parts.  DONE

patch7: Add BCM70015 support  MOSTLY DONE - some clean up needed


To me this makes more sense than trying to apply the patches as applied
to the linuxtv.org git repo since there's a lot of irrelevant code churn
and changes in commits which are undocumented in the log message along
with the fact they won't apply cleanly on top of the existing staging
driver anyway.

