Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3FNWCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:02:16 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53117 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159Ab3FNWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:02:12 -0400
Message-ID: <51BB92E1.7040906@hurleysoftware.com>
Date: Fri, 14 Jun 2013 18:02:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Ross Lagerwall <rosslagerwall@gmail.com>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-serial@vger.kernel.org
Subject: Re: Possible tty VT1 disallocate regression
References: <20130614204740.GA706@hobo.wolfson.cam.ac.uk> <20130614213543.GA1896@kroah.com>
In-Reply-To: <20130614213543.GA1896@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 05:35 PM, Greg KH wrote:
> On Fri, Jun 14, 2013 at 09:47:40PM +0100, Ross Lagerwall wrote:
>> Hi,
>>
>> Ever since commit 421b40a6286e ("tty/vt: Fix vc_deallocate() lock
>> order"), the first VT does not clear when I log out.  AFAIK, this means
>> that disallocation is not working?  The problem only affects the first
>> VT, the others clear when logging out.
>
> And if you revert that patch, does it all start working again?
>
> thanks,
>
> greg k-h
>
> p.s. In the future, please cc: the people who handled the patch you are
> asking about, otherwise stuff like this often gets missed in the noise
> of lkml.

I've already been re-reviewing the VT indexing to see if or what I missed.

Thanks,
Peter Hurley

