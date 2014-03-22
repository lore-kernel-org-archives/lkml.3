Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaCVVD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:03:28 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35855 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaCVVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:03:24 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of commands
Date: Sat, 22 Mar 2014 22:01:06 +0100
Message-ID: <1553572.xqrhDm938v@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.12.3 (Linux/3.2.55-gentoo; KDE/4.12.3; x86_64; ; )
In-Reply-To: <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
References: <20140308010611.468206150@linuxfoundation.org> <20140322165145.GA12870@kroah.com> <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original Message from: Ben Hutchings <ben@decadent.org.uk>
> 
> Andreas, could you test whether this regression is also present in
> 3.2.55?  This patch is based on my backport for 3.2.y.
> 

3.2.55 is OK here.
