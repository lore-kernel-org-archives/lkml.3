Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaIHP4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:56:46 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53983 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaIHP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:56:45 -0400
Message-ID: <540DD1C3.7000800@kernel.dk>
Date: Mon, 08 Sep 2014 09:56:51 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-3.18] blkcg: remove blkcg->id
References: <20140907231520.GA5061@mtj.dyndns.org>
In-Reply-To: <20140907231520.GA5061@mtj.dyndns.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2014 05:15 PM, Tejun Heo wrote:
> blkcg->id is a unique id given to each blkcg; however, the
> cgroup_subsys_state which each blkcg embeds already has ->serial_nr
> which can be used for the same purpose.  Drop blkcg->id and replace
> its uses with blkcg->css.serial_nr.  Rename cfq_cgroup->blkcg_id to
> ->blkcg_serial_nr and @id in check_blkcg_changed() to @serial_nr for
> consistency.

Thanks Tejun, applied.

-- 
Jens Axboe

