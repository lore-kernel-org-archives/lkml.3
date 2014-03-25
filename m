Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaCYJb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:31:29 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:37591 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaCYJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:31:26 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of commands
Date: Tue, 25 Mar 2014 10:29:15 +0100
Message-ID: <3326096.NJGQSn5Qfa@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.12.3 (Linux/3.4.83-gentoo-r1; KDE/4.12.3; x86_64; ; )
In-Reply-To: <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk>
References: <20140308010611.468206150@linuxfoundation.org> <1553572.xqrhDm938v@tux200s> <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original Message from: Ben Hutchings <ben@decadent.org.uk>
> 
> One piece of my backport to 3.2.y went missing in the forward-port to
> 3.4.y.  Can you test 3.4.83 with this patch on top?
> 
> Ben.

iwlwifi works with the additional patch, thanks :)

