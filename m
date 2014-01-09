Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaAITIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:08:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34576 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbaAITHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:07:44 -0500
Message-ID: <52CEF383.3070405@arm.com>
Date: Thu, 09 Jan 2014 19:07:47 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep.Holla@arm.com, "x86@kernel.org" <x86@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] drivers: base: support cpu cache information
 interface to userspace via sysfs
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com> <1389209168-17189-2-git-send-email-sudeep.holla@arm.com> <20140108202826.GF8417@kroah.com>
In-Reply-To: <20140108202826.GF8417@kroah.com>
X-OriginalArrivalTime: 09 Jan 2014 19:07:39.0965 (UTC) FILETIME=[10FD8ED0:01CF0D6E]
X-MC-Unique: 114010919074200301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 20:28, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2014 at 07:26:06PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>> +#define define_one_ro(_name) \
>> +static struct cache_attr _name = \
>> +	__ATTR(_name, 0444, show_##_name, NULL)
> 
> In the future, we do have __ATTR_RO(), which should be used instead.
> You should never use __ATTR() on it's own, if at all possible.  I'm
> sweeping the tree for all usages and fixing them slowly up over time.
> 

Understood, will fix it.

Regards,
Sudeep


