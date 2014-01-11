Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaAKLT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:19:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19717 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaAKLTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:19:51 -0500
Date: Sat, 11 Jan 2014 14:19:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Staging: lustre: Refactor the function
 interval_erase_color() in /lustre/ldlm/interval_tree.c
Message-ID: <20140111111931.GV30234@mwanda>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
 <1389438033-5928-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389438033-5928-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 04:30:33PM +0530, Monam Agarwal wrote:
> The function interval_erase_color() in lustre/ldlm/interval_tree.c is
> too long and can be refactored. Most of the statements are same for if
> and else conditions. I am passing a new variable n based on which the
> differences are recognised.
> 

"n" stands for number, but what is the it the number of?

regards,
dan carpenter

