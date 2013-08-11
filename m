Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3HKIJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 04:09:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54677 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3HKIJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 04:09:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,855,1367996400"; 
   d="scan'208";a="67781576"
X-IronPort-AV: E=Sophos;i="4.89,855,1367996400"; 
   d="scan'208";a="582521389"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Thomas Fjellstrom <thomas@fjellstrom.ca>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 044/102] ath: wil6210: Fix build error
Date: Sun, 11 Aug 2013 11:09:24 +0300
Message-ID: <1415030.bySVpiWVc1@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.10.5 (Linux/3.8.0-27-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130809015020.242015405@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org> <20130809015020.242015405@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 08, 2013 06:57:20 PM Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.

This one is good for stable. I'd suggest to apply also commit
c6c7788fe26fdc91e729f60742815ccdb505fd81 - wil6210: drop -Werror compiler flag
it is not in Linus's tree yet, but in Linville's wireless-next

Thanks, Vladimir
