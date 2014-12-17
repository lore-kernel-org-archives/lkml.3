Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbaLQRIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:08:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQRIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:08:41 -0500
Message-ID: <5491B88E.3070906@canonical.com>
Date: Wed, 17 Dec 2014 12:08:30 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kamal Mostafa <kamal.mostafa@canonical.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        davidx.m.ertman@intel.com, jeffrey.e.pieper@intel.com,
        jeffrey.t.kirsher@intel.com, LKML <linux-kernel@vger.kernel.org>,
        linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH][v3.13.y] e1000e: Fix no connectivity when driver loaded with
 cable out
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please consider including mainline commit b20a774 in the next v3.13.y
stable release.  It was included in the mainline tree as of v3.15-rc1. 
It has been tested and confirmed to resolve
http://bugs.launchpad.net/bugs/1400365 .

commit b20a774495671f037e7160ea2ce8789af6b61533
Author: David Ertman <davidx.m.ertman@intel.com>
Date:   Tue Mar 25 04:27:55 2014 +0000

    e1000e: Fix no connectivity when driver loaded with cable out



Sincerely,
Joseph Salisbury


