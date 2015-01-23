Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbbAWJCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:02:32 -0500
Received: from smtp-out-161.synserver.de ([212.40.185.161]:1070 "EHLO
	smtp-out-157.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752692AbbAWJCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:02:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6989
Message-ID: <54C20CA5.7050204@metafoo.de>
Date: Fri, 23 Jan 2015 09:56:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: imu: adis16400: Fix sign extension
References: <1421969642-18167-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1421969642-18167-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:34 AM, Rasmus Villemoes wrote:
> The intention is obviously to sign-extend a 12 bit quantity. But
> because of C's promotion rules, the assignment is equivalent to "val16
> &= 0xfff;". Use the proper API for this.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

