Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3AQSgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:36:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3AQSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:35:58 -0500
Message-ID: <50F84441.8080300@canonical.com>
Date: Thu, 17 Jan 2013 13:34:41 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        pkondeti@codeaurora.org, Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
CC: stable@vger.kernel.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org
Subject: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay region
 during unlink
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please consider reverting commit 
3d037774b42ed677f699b1dce7d548d55f4e4c2b in mainline as well as in the 
current stable releases.  It was included upstream as of v3.6-rc6.  This 
commit introduced a regression, described in the following bug report:

http://bugs.launchpad.net/bugs/1088733

Reverting commit 3d037774b42ed677f699b1dce7d548d55f4e4c2b in the v3.2 
kernel has been confirmed to resolve the aforementioned bug.


Sincerely,

Joseph Salisbury

