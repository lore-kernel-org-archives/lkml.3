Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3I0DRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:17:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3I0DR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:17:28 -0400
Date: Thu, 26 Sep 2013 20:17:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH CHAR-MISC-NEXT 4/4] Intel MIC Header File warning fix.
Message-ID: <20130927031727.GC13086@kroah.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
 <a12a4d52202e0511d03a0e6b85ef5d70348d64cf.1380241770.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a12a4d52202e0511d03a0e6b85ef5d70348d64cf.1380241770.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 06:10:23PM -0700, Sudeep Dutt wrote:
> usr/include/linux/mic_ioctl.h:37:
> found __[us]{8,16,32,64} type without #include <linux/types.h>

What is that from?  What does it mean?

confused,

greg k-h
