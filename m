Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3EVMch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:32:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:22207 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3EVMcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:32:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,719,1363158000"; 
   d="scan'208";a="306218210"
Message-ID: <519CBB7B.5060604@linux.intel.com>
Date: Wed, 22 May 2013 15:35:07 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, sarah.a.sharp@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] usb: add usb2 Link PM variables to sysfs and
 usb_device
References: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com> <1369133017-3035-5-git-send-email-mathias.nyman@linux.intel.com> <20130521134819.GA15963@kroah.com>
In-Reply-To: <20130521134819.GA15963@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:48 PM, Greg KH wrote:
> On Tue, May 21, 2013 at 01:43:37PM +0300, Mathias Nyman wrote:
>> Adds abitilty to tune L1 timeout (inactivity timer for usb2 link sleep)
>> and BESL (best effort service latency)via sysfs.
>
> If you add/remove/change sysfs files, you also need to do the same in
> Documentation/ABI/ at the same time.  Please do so in this patch.
>
> thanks,
>
> greg k-h

Thanks for the feedback, I'll add it and submit a new version.

-Mathias
