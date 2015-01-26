Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbbAZVHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:07:49 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58082 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbAZVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:07:47 -0500
Message-ID: <54C6ACA1.6000909@kernel.org>
Date: Mon, 26 Jan 2015 21:07:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: imu: adis16400: Fix sign extension
References: <1421969642-18167-1-git-send-email-linux@rasmusvillemoes.dk> <54C20CA5.7050204@metafoo.de>
In-Reply-To: <54C20CA5.7050204@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 08:56, Lars-Peter Clausen wrote:
> On 01/23/2015 12:34 AM, Rasmus Villemoes wrote:
>> The intention is obviously to sign-extend a 12 bit quantity. But
>> because of C's promotion rules, the assignment is equivalent to "val16
>> &= 0xfff;". Use the proper API for this.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
> 
Applied to the fixes-togreg branch of iio.git and cc'd to stable.
