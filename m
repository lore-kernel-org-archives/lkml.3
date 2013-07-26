Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3GZRDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:03:22 -0400
Received: from mail-gh0-f171.google.com ([209.85.160.171]:47635 "EHLO
	mail-gh0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3GZRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:03:20 -0400
Date: Fri, 26 Jul 2013 13:03:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is
 offline
Message-ID: <20130726170315.GG3013@htj.dyndns.org>
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
 <20130725153121.GF26107@mtj.dyndns.org>
 <51F1DB45.90905@cn.fujitsu.com>
 <20130726030711.GA30195@mtj.dyndns.org>
 <51F1F138.2060902@cn.fujitsu.com>
 <20130726102240.GA30786@mtj.dyndns.org>
 <CACvQF52TC4L58WwvhJ9sYiBj2vFdLG2iCb5Fvs2a8Ti19DpAWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52TC4L58WwvhJ9sYiBj2vFdLG2iCb5Fvs2a8Ti19DpAWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 12:55:12AM +0800, Lai Jiangshan wrote:
> but sometimes the cpu is offline for long time.
> and maybe the adminstrator want to reclaim the resource..
> 
> Add a boot option or sysfs switch?

No, we don't do that to save 64k.

-- 
tejun
