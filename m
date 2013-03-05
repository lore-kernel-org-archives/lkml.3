Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3CEWW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:22:57 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64480 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116Ab3CEWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:22:55 -0500
Message-ID: <1362522169.16460.151.camel@x61.thuisdomein>
Subject: Re: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER
 configurations
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 23:22:49 +0100
In-Reply-To: <20130305215408.GD10965@kroah.com>
References: <1362511248.16460.113.camel@x61.thuisdomein>
	 <20130305215408.GD10965@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 22:22:50.0322 (UTC) FILETIME=[F8D9BB20:01CE19EF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 05:54 +0800, Greg KH wrote:
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.

0) Actually I just copied the addresses included in commit
e121aefa7d9f10eee5cf26ed47129237a05d940b upstream without really
thinking.

1) But actually thinking about this: that upstream commit did end up in
the (longterm) v3.4.y series. And my patch is also relevant for the
v3.8.y series. Can't this patch, that fixes an obviously bogus commit,
which was important enough for stable, be itself submitted with
CC:stable?


Paul Bolle

