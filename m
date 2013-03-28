Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab3C1OpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:45:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35042 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3C1OpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:45:03 -0400
Date: Thu, 28 Mar 2013 14:45:02 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Hong Zhiguo <honkiko@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 5/6] scsi: replace obsolete NLMSG_* with type safe nlmsg_*
Message-ID: <20130328144502.GG23043@casper.infradead.org>
References: <1364403195-32839-1-git-send-email-honkiko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364403195-32839-1-git-send-email-honkiko@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/13 at 12:53am, Hong Zhiguo wrote:
> Signed-off-by: Hong Zhiguo <honkiko@gmail.com>

There are some formatting errors but the Netlink bits themselves
look good.
