Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3GLCwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:52:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3GLCwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:52:36 -0400
Message-ID: <51DF6F6B.9050809@redhat.com>
Date: Fri, 12 Jul 2013 10:52:27 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: airlied@linux.ie, vgoyal@redhat.com, bhe@redhat.com, chaowang@redhat.com,
        linux-kernel@vger.kernel.org, ishii.hironobu@jp.fujitsu.com
Subject: Re: PCIE resetting graphic card
References: <51DF6446.9090105@redhat.com> <51DF6C5D.1020904@jp.fujitsu.com>
In-Reply-To: <51DF6C5D.1020904@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takao
On 07/12/2013 10:39 AM, Takao Indoh wrote:
> Hi Dave,
> 
> (2013/07/12 11:04), Dave Young wrote:
>> Hi, Takao
>>
>> I know you are working on the PCIE resetting patches for the iommu kdump
>> issue.
>>
>> You explicitly excluded the graphic card in your patch. I have some
>> questions about this. Why can't we reset the graphic card like other
>> pcie devices?
> 
> As far as I tested, the monitor blacks out after video controller is
> reset, and we cannot know what's going on. So, for now display device is
> not reset in my patch.
> 
> I'm not sure what we need to do to recover graphic card after its reset,
> but my colleague said that we need to run BIOS code to get back legacy
> VGA mode after reset. It seems not to be easy:-(
> 
> Maybe this document is helpful to do this.
> http://www.coreboot.org/images/2/2b/Vgabios.pdf

Thanks for quick response and the info about vgabios. It's awkward that
we can not switch back to VGA mode.

-- 
Thanks
Dave
