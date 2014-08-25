Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaHYOrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:47:19 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:63812 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaHYOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:47:14 -0400
Date: Mon, 25 Aug 2014 10:47:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Message-ID: <20140825144710.GA21688@htj.dyndns.org>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140825141220.GA31066@mtj.dyndns.org>
 <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
> My point here is that attaching and detaching are a pair of operations.

There is no detaching from a cgroup.  A task is always attached to a
cgroup whether that's a root or non-root cgroup.

Thanks.

-- 
tejun
