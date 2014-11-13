Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbaKMLSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:18:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43948 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbaKMLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:18:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141113103607.GB17038@mwanda>
References: <20141113103607.GB17038@mwanda>
Date: Thu, 13 Nov 2014 13:18:37 +0200
Message-ID: <CAE1zot+qyoae5zogSfBNHv93c0KFE2kLf9cnWyes-247O60Lig@mail.gmail.com>
Subject: Re: [patch 2/2 -next] mfd: dln2: a couple endian fixes
From: Octavian Purdila <octavian.purdila@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:36 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> Sparse catches a couple endian bugs.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Octavian Purdila <octavian.purdila@intel.com>
