Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3GHQnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:43:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3GHQn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:43:29 -0400
Message-ID: <51DAEC2C.7070800@canonical.com>
Date: Mon, 08 Jul 2013 12:43:24 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kamal Mostafa <kamal.mostafa@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
CC: stable@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        devel@linuxdriverproject.org, LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: [PATCH][v3.8.y] Drivers: hv: Execute shutdown in a thread context
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please consider including upstream commit:
3dd6cb497198a0533a2530b6a345c60c9a29b9bc in the next v3.8.y release.  It
was included upstream as of v3.9-rc1.  It has been tested and confirmed
to resolve http://bugs.launchpad.net/bugs/1180419 .

commit 3dd6cb497198a0533a2530b6a345c60c9a29b9bc
Author: K. Y. Srinivasan <kys@microsoft.com>
Date:   Wed Jan 23 17:42:45 2013 -0800

    Drivers: hv: Execute shutdown in a thread context


Sincerely,
Joseph Salisbury

