Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3FXQfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:35:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3FXQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:35:38 -0400
Message-ID: <51C87554.8010503@canonical.com>
Date: Mon, 24 Jun 2013 12:35:32 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130529 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Subject:  [v3.8 Regression]  UHCI: OHCI: implement new semantics
 for URB_ISO_ASAP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

A bug was opened against the Ubuntu distro[0].  It is believed that the
following commits introduced the regression:

commit c44b225077bb1fb25ed5cd5c4f226897b91bedd4
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Oct 1 10:32:09 2012 -0400

    UHCI: implement new semantics for URB_ISO_ASAP

commit 6a41b4d3fe8cd4cc95181516fc6fba7b1747a27c
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Oct 1 10:32:15 2012 -0400

    OHCI: implement new semantics for URB_ISO_ASAP




The regression was introduced as of v3.8-rc1. 

I see the following commit was created to address a similar issue to this:

commit e1944017839d7dfbf7329fac4bdec8b4050edf5e
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Tue May 14 13:57:19 2013 -0400

    USB: fix latency in uhci-hcd and ohci-hcd

I created a test kernel with commit
e1944017839d7dfbf7329fac4bdec8b4050edf5e.  However, folks affected state
this bug still exists with commit e194401.  It is also reported that
this bug exists in the latest Mainline kernel.

I see that you are the author of these patches, so I wanted to get your
opinion on the issue.

Thanks,

Joe

[0] http://pad.lv/1191603

