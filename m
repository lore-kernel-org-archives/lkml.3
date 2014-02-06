Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaBFIhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:37:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:55331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaBFIhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:37:14 -0500
Message-ID: <1391675824.12789.3.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Johannes Berg <johannes@sipsolutions.net>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Feb 2014 09:37:04 +0100
In-Reply-To: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com> (sfid-20140206_024518_181987_99107ED8)
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 (sfid-20140206_024518_181987_99107ED8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that instead of the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.

I believe both iw and wpa_supplicant already have the reason code
printout, and if you're diagnosing connectivity issues then you're
probably using those anyway (e.g. iw event -t), so I don't really see
much point in adding this to the kernel?

johannes

