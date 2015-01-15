Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbbAOMmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:42:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbAOMmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:42:08 -0500
Date: Thu, 15 Jan 2015 15:41:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Simone Weiss <simone.weiss@fau.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        helene.gsaenger@studium.fau.de, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4 4/6] dgnc: checkpatch: macros in enclosed parantheses
Message-ID: <20150115124137.GD6201@mwanda>
References: <20150114131815.GG5571@mwanda>
 <1421325159-970-1-git-send-email-simone.weiss@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421325159-970-1-git-send-email-simone.weiss@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 01:32:39PM +0100, Simone Weiss wrote:
> dpacompat.h and digi.h partly define the same macros, so it is necessary to
> change them both. I also removed some defines as they were unnecessary, 
> because they were already defined, or because they were never used.

Thanks for checking on this.

regards,
dan carpenter

