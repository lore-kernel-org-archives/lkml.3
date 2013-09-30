Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3I3TyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:54:09 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56864 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3I3TyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:54:07 -0400
Date: Mon, 30 Sep 2013 15:54:03 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCHSET] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20130930195403.GB8091@htj.dyndns.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
 <20130928221513.GA20640@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928221513.GA20640@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 28, 2013 at 06:15:13PM -0400, Tejun Heo wrote:
> On the second thought, 0011 seems too dangerous, especially for pci IO
> BAR regions.  Grumble, looks like I'll have to break out the bin read
> path.  Please ignore patches >= 0009.  I'll update them and repost.

Please ignore the whole series for now.  It seems like we'll need a
separate read path for the existing sysfs interface anyway and
seq_file interface should be added separately.  Will post updated
patches soon.

Thanks.

-- 
tejun
