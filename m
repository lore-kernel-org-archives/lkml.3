Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaCaUGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:06:17 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:55983 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaCaUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:06:16 -0400
Date: Mon, 31 Mar 2014 16:06:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
Message-ID: <20140331200209.GD28901@mtj.dyndns.org>
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com>
 <5335661E.7030408@cn.fujitsu.com>
 <53397E6F.6050600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53397E6F.6050600@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:40:47PM +0800, Lai Jiangshan wrote:
> Ping

Lai, I'll keep the mail tagged but can you pleaes ping me once -rc1
drops?  While it is an actual bug, given that it'd be pretty difficult
to trigger, I don't think it's too urgent.

Thanks!

-- 
tejun
