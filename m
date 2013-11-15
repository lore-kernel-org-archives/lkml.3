Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3KORoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:44:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3KORoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:44:18 -0500
Message-ID: <52865D6B.1080902@canonical.com>
Date: Fri, 15 Nov 2013 12:44:11 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: rafael.j.wysocki@intel.com
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [v3.11][3.12][Regression]  ACPI / processor: Use common hotplug infrastructure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

A kernel bug affecting several users was opened against Ubuntu[0]. 
After a bisect, it was found the following commit introduced the regression:

commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date: Fri May 3 00:26:22 2013 +0200

    ACPI / processor: Use common hotplug infrastructure

The regression was introduced as of v3.11-rc1.

This commit doesn't revert cleanly in 3.12, and requires the revert of
other commits as well.  I wanted to get your feedback since you are the
author.

   
Thanks,
   
Joe

http://pad.lv/1237336
