Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaHFOgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:36:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaHFOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:36:35 -0400
Date: Wed, 6 Aug 2014 07:36:01 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "oort10@gmail.com" <oort10@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] staging:r8190: coding style: Fixed checkpatch
 reported Error
Message-ID: <20140806143601.GB13552@kroah.com>
References: <1406785411-12538-1-git-send-email-sanjeev_sharma@mentor.com>
 <1406785411-12538-4-git-send-email-sanjeev_sharma@mentor.com>
 <FDC088D3B5555644AE135ED28A7ABDE94DF1BA98@EU-MBX-02.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE94DF1BA98@EU-MBX-02.mgc.mentorg.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 09:33:56AM +0000, Sharma, Sanjeev wrote:
> Hello All,
> 
> I have submitted few patches last week and also get reply from Greg that patches will show up in linux-next tree and in parallel I need to submit new patches  and now Looks like I need to
> Sync my tree with linux-next tree before start working on New set of change and as soon as I am pulling change I always get conflicts.
> 
> Anyone has idea who to overcome this problem ?

Use a separate branch for your work, and also never use 'git pull' with
linux-next, that just will not work at all.

greg k-h
