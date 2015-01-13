Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbbAMSeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:34:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbbAMSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:34:43 -0500
Date: Tue, 13 Jan 2015 10:34:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kiran Raparthy <kiran.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mike Chan <mike@android.com>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, JP Abgrall <jpa@google.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>
Subject: Re: [RFC 1/2] misc: uidstat: Add uid stat driver to collect network
 statistics.
Message-ID: <20150113183441.GA24908@kroah.com>
References: <1421147642-28360-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421147642-28360-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:44:01PM +0530, Kiran Raparthy wrote:
> From: Mike Chan <mike@android.com>
> 
> misc: uidstat: Add uid stat driver to collect network statistics.
> 
> To analyze application's network statistics, we need a mechanism to export
> the UID based statistics to userspace so that userspace tools can use the
> exported numbers and generate the report against the UID.
> 
> This patch allows the user to explore the UID based network statistics
> exported to /proc/uid_stat.

This is a joke, right?  It's not April 1 yet people, why send this in
January?

confused,

greg k-h
