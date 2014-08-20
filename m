Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaHTGgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:36:51 -0400
Received: from smtp-out-021.synserver.de ([212.40.185.21]:1058 "EHLO
	smtp-out-021.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaHTGgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:36:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13397
Message-ID: <53F441FF.9090304@metafoo.de>
Date: Wed, 20 Aug 2014 08:36:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>, jic23@kernel.org,
        gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio
References: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 08:41 AM, Sanjeev Sharma wrote:
> This is a patch to the iio which will move all platform_data
> into include/linux/iio.

It should be moved together with the driver.
