Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161Ab3EBPyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:54:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:14405 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008Ab3EBPyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="296595188"
Date: Thu, 2 May 2013 17:54:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help with the MFD subsystem
Message-ID: <20130502155447.GM4563@zurbaran>
References: <20130502152131.GM25256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502152131.GM25256@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, May 02, 2013 at 04:21:31PM +0100, Lee Jones wrote:
> Hi Sam,
> 
> I understand that you're snowed-under beneath quite a large pile of
> work items at the moment. Would you like me to lend a hand maintaining
> the MFD subsystem? At least until you are spared some of your more
> time consuming tasks. I'd be glad to help out if you think it'll help
> speed up the patch submission to application time.
It would certainly help.
I would appreciate if you could start by taking care of all the ST-E and ST-M
drivers (The whole ABx family, the DB8500 one, the STMPE and maybe the
STAx211) and sending me pull requests for them. That's already a significant
part of the patch flow, so quite hepful.

How does that sound to you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
