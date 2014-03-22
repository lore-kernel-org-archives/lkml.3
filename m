Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaCVQaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:30:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56458 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaCVQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:30:11 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>
Subject: Re: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of commands
Date: Sat, 22 Mar 2014 17:28:02 +0100
Message-ID: <174441141.AshFyuFNQG@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.12.3 (Linux/3.14.0-rc7+; KDE/4.12.3; x86_64; ; )
In-Reply-To: <20140322162501.GA13385@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org> <8891481.xyaW2OauMW@tux200s> <20140322162501.GA13385@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original Message from: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Does Linus's tree also have this problem for you?  Or does it work
> there?  If it works there, perhaps we just missed backporting something
> to 3.4?
> 

Other trouble aside, iwlwifi works fine - writing this from today's build of 
3.14.0-rc7+.
