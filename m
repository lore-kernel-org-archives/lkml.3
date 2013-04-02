Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3DBPb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:31:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53540 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3DBPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:31:55 -0400
Message-ID: <515AF9E9.1020603@wwwdotorg.org>
Date: Tue, 02 Apr 2013 09:31:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
References: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com> <512F9F0B.1040303@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6E4F7216C0@BGMAIL02.nvidia.com> <5134D210.3060405@wwwdotorg.org> <20130305003423.GA23996@kroah.com> <D958900912E20642BCBC71664EFECE3E6E50BE434F@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E50BE434F@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 01:12 AM, Venu Byravarasu wrote:
>> gregkh@linuxfoundation.org wrote at Tuesday, March 05, 2013 6:04 AM:
>> On Mon, Mar 04, 2013 at 09:55:44AM -0700, Stephen Warren wrote:
>>> On 03/04/2013 12:55 AM, Venu Byravarasu wrote:
>>>> Stephen Warren wrote at Thursday, February 28, 2013 11:47 PM:
>>>>> On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
>>>>>> To clear any configurations made by U-Boot on Tegra USB controller,
>>>>>> reset it before init in probe.
...
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  
> Hi Greg,
> 
> Stephen initially thought that the patch can be taken through tegra tree, along with
> other patches posted at  http://marc.info/?l=linux-tegra&m=136361016003625&w=2 .
> As some other issues are blocking that patch series, can this change be merged
> independent of that patch series via USB tree?
> 
> The original change can be seen at http://marc.info/?l=linux-usb&m=136203353205291&w=2  

Venu, you should simply repost the patch; I'm sure its not in anyone's
email inbox any more.
