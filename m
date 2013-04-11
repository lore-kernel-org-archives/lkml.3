Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab3DKVbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:31:48 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:52587 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753101Ab3DKVbp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:31:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: Daniel Drake <dsd@laptop.org>, Marco Cesarano <marco@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Apr 2013 14:29:55 -0700
Subject: RE: [ 099/171 ] mwifiex: fix race when queuing commands
Thread-Topic: [ 099/171 ] mwifiex: fix race when queuing commands
Thread-Index: Ac429gD5IDpmXxNhT6OoNUps3mzirAAA+asg
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE96BE2@SC-VEXCH1.marvell.com>
References: <20130411202503.783159048@goodmis.org>
 <20130411202602.327870069@goodmis.org>
In-Reply-To: <20130411202602.327870069@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> 3.6.11.2 stable review patch.
> If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> [ Upstream commit 00d7ea11ff0783e24fe70778f3141270b561aaa1 ]
> 
> Running the following script repeatedly on XO-4 with SD8787
> produces command timeout and system lockup.

The patch 099/171 and 100/171 (mwifiex: skip pending commands after function shutdown) are intended for 3.8 to solve a race issue found on XO-4 platform.

For 3.7 and lower kernel versions, these patches are not verified.
I'd suggest do not merge them to 3.6.11.x to avoid potential side effects.

Later, if we get a user report of the same problem on 3.6, we can verify these patches on his/her platform and add these patches back.

Thanks,
Bing

