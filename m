Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaLWURD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:17:03 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:55275 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:17:00 -0500
Message-ID: <5499CDB9.6050602@ridgerun.com>
Date: Tue, 23 Dec 2014 14:16:57 -0600
From: Carsten Behling <carsten.behling@ridgerun.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usb: musb: Scheduling of interrupt endpoints
References: <54947E99.4010908@ridgerun.com> <5499835B.508@ridgerun.com> <20141223182737.GF9147@saruman>
In-Reply-To: <20141223182737.GF9147@saruman>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 12/23/2014 12:27 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Dec 23, 2014 at 08:59:39AM -0600, Carsten Behling wrote:
>> Would it help if I send a patch as a suggestion and as basis for
>> discussion?
> yes, it would also help if you didn't top-post :-)
>
So would you suggestion be to port that feature from the old 
linux-2.6.32.17-psp03.01.01.39
kernel from TI or should we rather add a tree based implementation as 
done for OHCI?

-Carsten
