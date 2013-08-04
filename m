Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3HDTg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 15:36:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:44714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3HDTg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 15:36:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,813,1367996400"; 
   d="scan'208";a="381758354"
Message-ID: <51FEAD39.2030909@linux.intel.com>
Date: Sun, 04 Aug 2013 12:36:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC v01 0/3] Power Capping Framework
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com> <20130802222909.GA28831@kroah.com> <51FC4635.1040909@linux.intel.com> <20130803005336.GB31696@kroah.com>
In-Reply-To: <20130803005336.GB31696@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/2013 5:53 PM, Greg KH wrote:
>> I will post the one client driver, which is already using this
>> framework as this series.
>>> Ideally you will have more than one client driver submitted, as a
>>> "framework" for just one driver seems a bit odd, don't you think?
>> There are other groups and vendors interested in using this
>> framework. But they want to make sure that this
>> framework can go to upstream Linux. We will provide one client using
>> this framework at this time.
>> Do you think this is a problem?
>
> I would love to see the feedback from those groups and vendors as well,
> to ensure that they agree with this.  Ideally, they would sign off on
> the patches, and provide clients that work with the framework at the
> same time.  Otherwise, I just have to take your word for it :)

I suspect that in some ways Intel is a year or two ahead in this regard,
we'll see if others are willing to speak up yet ;-)


