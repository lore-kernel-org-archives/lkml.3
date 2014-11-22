Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaKVOCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:02:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaKVOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:02:01 -0500
Date: Sat, 22 Nov 2014 06:00:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>
Subject: Re: [PATCH] Revert "staging: sm7xxfb: remove driver"
Message-ID: <20141122140040.GA28422@kroah.com>
References: <20141120170925.5a435436@gandalf.local.home>
 <20141120232329.GA27669@kroah.com>
 <20141122070202.GB4490@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122070202.GB4490@sudip-PC>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 12:32:02PM +0530, Sudip Mukherjee wrote:
> 2) most important - I do not have the hardware. So from the TODO list
> dual head and 2D acceleration support will be tough without actually
> checking on the hardware.

For a driver like this, if you don't have the hardware, I wouldn't
recommend taking on the task of trying to fix it up and become the
maintainer, sorry.

greg k-h
