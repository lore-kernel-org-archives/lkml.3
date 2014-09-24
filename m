Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaIXJBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:01:10 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:38817 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaIXJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:01:08 -0400
Date: Wed, 24 Sep 2014 10:00:05 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, angus@agibson.me,
        tklauser@distanz.ch, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] et131x: Promote staging et131x driver to drivers/net
Message-ID: <20140924090004.GA5097@leicester.auvation.com>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
 <1411502723-4628-1-git-send-email-mark.einon@gmail.com>
 <1411506437.29268.13.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411506437.29268.13.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:07:17PM -0700, Joe Perches wrote:
> On Tue, 2014-09-23 at 21:05 +0100, Mark Einon wrote:
> > This patch moves the et131x gigabit ethernet driver from drivers/staging
> > to drivers/net/ethernet/agere.
> 
> checkpatch type modification you might consider:
> 
> Reduce logging line count by consolidating repeated dev_warn
> Use ether_addr_copy
> Line wrapping for 80 columns
> Remove unnecessary parentheses
> Remove unnecessary OOM message

Considered and done, thanks.

Mark
