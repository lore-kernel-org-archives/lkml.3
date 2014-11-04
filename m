Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaKDWUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:20:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaKDWUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:20:19 -0500
Message-ID: <54595116.1050802@canonical.com>
Date: Tue, 04 Nov 2014 17:20:06 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: pratyush.anand@st.com
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, dan.j.williams@intel.com,
        pmladek@suse.cz, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        peter.chen@freescale.com, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [Regression][v3.17][v3.18]   USB: Fix persist resume of some SS USB
 devices
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pratyush,

A kernel bug report was opened against Ubuntu [0].  After a kernel
bisect, it was found that reverting the following commit resolved this bug:

commit a40178b2fa6ad87670fb1e5fa4024db00c149629
Author: Pratyush Anand <pratyush.anand@st.com>
Date:   Fri Jul 18 12:37:10 2014 +0530

    USB: Fix persist resume of some SS USB devices

The regression was introduced as of v3.17-rc1.  The regression still
exists in the 3.18-rc3 mainline kernel, and has made it's way into the
stable kernels.

I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?
   

Thanks,
   
Joe

[0] http://pad.lv/1384041

