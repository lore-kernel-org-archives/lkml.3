Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3GCPqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:46:48 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33819 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3GCPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:46:46 -0400
Message-ID: <51D44752.3000303@linux.vnet.ibm.com>
Date: Wed, 03 Jul 2013 21:16:26 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH 4] mce: acpi/apei: Add a sysctl to control page offlining
 on firmware report
References: <20130701153728.6197.14022.stgit@localhost.localdomain> <20130702125137.7388.97225.stgit@localhost.localdomain> <20130703144641.GC13951@pd.tnic>
In-Reply-To: <20130703144641.GC13951@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070315-5564-0000-0000-000008A423DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 08:16 PM, Borislav Petkov wrote:
> On Tue, Jul 02, 2013 at 06:24:00PM +0530, Naveen N. Rao wrote:
>> I am adding another patch here to disable page offlining in case the firmware
>> starts acting up.
>>
>> Thanks,
>> Naveen
>>
>> --
>>
>> Add a sysctl memory_failure_soft_offline to control what is done on receipt of
>> firmware ghes notification for a corrected error. By default, kernel tries
>> to soft-offline the page immediately. If set to 0, no action is taken.
>
> What is the rationale for that? Are we adding it just in case, as a
> chicken bit or do you have a specific case?
>
> If the second, we'd love to hear about it in the commit message. :)

Nope, this is a just-in-case thing. I think you or Tony asked to have 
this in a previous discussion so that we're covered if firmware starts 
acting up. Other than that, I'm ok if this is left out.


Thanks,
Naveen

