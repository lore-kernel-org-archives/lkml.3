Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbaFTTib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:38:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbaFTTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:38:29 -0400
Message-ID: <53A48DF6.9020503@oracle.com>
Date: Fri, 20 Jun 2014 15:39:34 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com> <20140620152312.GB11391@pd.tnic> <53A45627.6090306@oracle.com> <20140620155845.GC11391@pd.tnic> <53A45E67.7070000@oracle.com> <20140620175240.GE11391@pd.tnic>
In-Reply-To: <20140620175240.GE11391@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 01:52 PM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 12:16:39PM -0400, Boris Ostrovsky wrote:
>> But I think you still need to do the dance in the notifier to make
>> sure you are not trying to add/remove device if mcheck_init_device()
>> had failed earlier.
> mce_device_remove should be smart enough. Hint: mce_device_initialized
> cpumask.

What about mce_device_add()?

-boris

