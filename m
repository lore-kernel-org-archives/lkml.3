Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaLRWPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:15:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaLRWPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:15:05 -0500
Date: Thu, 18 Dec 2014 14:15:04 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 1/3 V2] mei: add ABI documentation for fw_status
 exported through sysfs
Message-ID: <20141218221504.GC10229@kroah.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B2CCED19D@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B2CCED19D@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 09:37:12AM +0000, Winkler, Tomas wrote:
> 
> 
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> > V2: rephrase the description
> >  Documentation/ABI/testing/sysfs-class-mei | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> Greg you've  included 'mei: export fw status registers through sysfs' to 3.19-rc1 pull request 
> but left this documentation patch out.

I don't remember what happened there, can you resend and I will queue it
up for after 3.19-rc1?

thanks,

greg k-h
