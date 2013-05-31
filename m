Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3FCPdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:33:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47156 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:33:34 -0400
Date: Fri, 31 May 2013 12:58:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-05-30
Message-ID: <20130531165827.GA2072@tuxdriver.com>
References: <20130530225232.GB14083@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530225232.GB14083@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 07:52:32PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> The following patches are important bug fixes for 3.10, plus the support for a
> new device. We do have three fixes from Johan. The first one is a fix to avoid
> LE-only devices to rely on the (inexistent) extended features data. The second
> patch fixes length checks on incoming L2CAP signalling PDUs so we can discard
> PDU whose size doesn't match the one reported in the header.
> The last one fixes the handling of power on failures, we now report proper
> errors to mgmt when hci_dev_open().
> 
> Please pull or let me know of any issues! Thanks.
> 
> 	Gustavo
> 
> ---
> 
> The following changes since commit f942d116b80feb3ae618a0d8ce2df6e853526d3c:
> 
>   brcmsmac: fix regression observed in 3.10-rc1 (2013-05-29 14:46:51 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to 0f9e216b0e12971af8a1d39c98c353c76533283b:
> 
>   Bluetooth: Fix mgmt handling of power on failures (2013-05-30 18:36:08 -0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
