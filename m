Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966289AbaLLLVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:21:37 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47197 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965845AbaLLLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:21:36 -0500
Message-ID: <548ACFBD.2000102@kernel.org>
Date: Fri, 12 Dec 2014 11:21:33 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 0/4] PM fixes for kxcjk-1013
References: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 16:23, Irina Tirdea wrote:
> This is a small set of power manangement fixes for kxcjk-1013 accel driver,
> mostly related to error handling.
> 
> Jonathan, you mentioned that you applied the first 2 patches from this series
> to the togreg branch, but I cannot find them there or on the testing branch.
> I have included them in v2, but they are identical to those in the first version.
Ah. I wrote those emails on a plane an remembered to send the mails later, but
not to push out the tree.  Will do that after today's catch up session.
> 
> Changes since v1:
>  - always set power state to off in case of i2c error (patch 3)
>  - patches 3 and 4 reviewed by Srinivas
> 
> Irina Tirdea (4):
>   iio: accel: kxcjk-1013: always power on device in resume
>   iio: accel: kxcjk-1013: only set power state if CONFIG_PM is defined
>   iio: accel: kxcjk-1013: error handling when set mode fails
>   iio: accel: kxcjk-1013: power off device if probe fails
> 
>  drivers/iio/accel/kxcjk-1013.c |   38 +++++++++++++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 

