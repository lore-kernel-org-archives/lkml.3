Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaAGOjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:39:33 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:34080 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaAGOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:39:24 -0500
Subject: Re: [PATCH 1/2] GenWQE: Fix endian issues detected by sparse
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, jim.epost@gmail.com, sfr@canb.auug.org.au,
        gregkh@linuxfoundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@01.org, weiyj.lk@gmail.com
In-Reply-To: <20140107124501.GK5443@mwanda>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
	 <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
	 <20140107064130.GA5494@mwanda>
	 <1389097816.15325.7.camel@oc7383187364.ibm.com>
	 <20140107124501.GK5443@mwanda>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 07 Jan 2014 15:39:16 +0100
Message-ID: <1389105556.15325.22.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010714-8372-0000-0000-00000843DBDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Am Dienstag, den 07.01.2014, 15:45 +0300 schrieb Dan Carpenter:
> Oops sorry...  I'm also still catching up from the holidays.  I think I
> was even CC'd on your earlier fix.

No problem. Let me send my latest set of patches for our GenWQE driver
which includes the ioctl return code fix and the removal of dev_err().
In addition fixes for properly compiling the driver on Sparc and Alpha.

> 
> regards,
> dan carpenter
> 

There are two more patches out from Wei Yongjun who removed obsolete
includes and fixed the error handling in genwqe_device_create().

Regards

Frank

