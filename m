Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3IMPZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:25:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55800 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3IMPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:25:44 -0400
Message-ID: <52332E6B.9060405@kernel.dk>
Date: Fri, 13 Sep 2013 09:25:31 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Akhil Bhansali <abhansali@stec-inc.com>
CC: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit
 declaration of function 'readq'
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com> <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 06:59 AM, Akhil Bhansali wrote:
> This patch takes care of warnings related to
> 1. Implicit function declaration for readq / writeq.
> 2. Warnings related to -Wformat.

Please do it on top of what was already fixed up. The readq, for
instance, is not even used in the driver.

-- 
Jens Axboe

