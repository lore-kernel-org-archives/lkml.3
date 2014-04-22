Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaDVJcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:32:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33260 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaDVJcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:32:52 -0400
Date: Tue, 22 Apr 2014 12:32:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] staging: gdm72xx: Minor cleanup
Message-ID: <20140422093234.GB26890@mwanda>
References: <532BF9B0.2080008@fastmail.fm>
 <20140418225229.GA28077@kroah.com>
 <53534051.2020504@fastmail.fm>
 <535340D6.9080604@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535340D6.9080604@fastmail.fm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 11:36:54AM +0800, Michalis Pappas wrote:
> 
> Removed line related to replacement of kernel_thread with kthread,
> as issue was fixed on ff5e4a1d2702582614996f6f6d005e9b5caadeb8.
> 

In the future, the way to specify a commit is:
ff5e4a1d2702 ('Staging: gdm72xx: gdm_usb: fix deprecated function
kernel_thread')

It's hard to remember which git hash goes with which commit.

regards,
dan carpenter

