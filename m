Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbaLKHXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:23:34 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41218 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaLKHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:23:33 -0500
Message-ID: <5489466B.5080901@tandemg.com>
Date: Thu, 11 Dec 2014 09:23:23 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: imx-sdma: fix indentation
References: <20141210080035.GA25812@ubuntu> <20141211045006.GI16827@intel.com>
In-Reply-To: <20141211045006.GI16827@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 06:50 AM, Vinod Koul wrote:
> On Wed, Dec 10, 2014 at 10:00:36AM +0200, Asaf Vertz wrote:
>> Fixed a coding style error, switch and case should be at the same indent
> Please use the right subsystem name for the patches

what subsystem name I should have used?
I used the one from the last patches in the log

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/drivers/dma/imx-sdma.c

