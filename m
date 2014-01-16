Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaAPRx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:53:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaAPRxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:53:24 -0500
Message-ID: <52D81C92.9050800@canonical.com>
Date: Thu, 16 Jan 2014 12:53:22 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [v3.11][v3.12][v3.13][Regression]  EISA: Initialize device before
 its resources
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
was found the following commit introduced this bug:

commit 26abfeed4341872364386c6a52b9acef8c81a81a
Author: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon Apr 15 14:34:02 2013 -0600

    EISA: Initialize device before its resources

The regression was introduced as of v3.10-rc1.

Reverting this commit has resolved the bug.  I wanted to get your
feedback, since you are the patch author.  Should we consider reverting
this commit in mainline and the stable trees?

Thanks,

Joe

