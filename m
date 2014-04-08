Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaDHOvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:51:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31646 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaDHOvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:51:39 -0400
Message-ID: <53440CEF.7090408@oracle.com>
Date: Tue, 08 Apr 2014 10:51:27 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: fs,seq_file: huge allocations for seq file reads
References: <53440B8B.1010304@oracle.com> <20140408144943.GA6165@redhat.com>
In-Reply-To: <20140408144943.GA6165@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 10:49 AM, Dave Jones wrote:
> On Tue, Apr 08, 2014 at 10:45:31AM -0400, Sasha Levin wrote:
>  
>  > It seems that when we attempt to read huge chunks of data from a seq file
>  > there would be no check for the size being read, leading to the kernel
>  > attempting to allocate huge chunks of data internally.
>  > 
>  > As far as I remember, there was a PAGE_SIZE limitation on those, but I'm
>  > not certain about that. Could someone please confirm it?
> 
> I've had this diff sitting around for a while to figure out which
> seq_file we're talking about.  I think Al wrote it, I forget..

I'll add it in.

I didn't realize it was a problem with a specific file, I thought it was
an issue with seq files in general.


Thanks,
Sasha
