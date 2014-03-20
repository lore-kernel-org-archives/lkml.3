Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbaCTQDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:03:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51918 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaCTQDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:03:11 -0400
Message-ID: <532B10F5.9010709@zytor.com>
Date: Thu, 20 Mar 2014 09:01:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH v2] x86, calgary: use 8M TCE table size by default
References: <1394463120-26999-1-git-send-email-chaowang@redhat.com> <20140320155411.GC29549@redhat.com>
In-Reply-To: <20140320155411.GC29549@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 08:54 AM, Vivek Goyal wrote:
> Hi hpa,
> 
> I am wondering how to make progress on calgary issue now. We do want to
> cleanup kexec-tools code and move to passing memory ranges in bootparams.
> 
> I see two choices here.
> 
> - Take this patch in so that new kernel code will work with modified
>   kexec-tools without any user intervention. (Both first and second kernel
>   need to be new). 
> 
> - Don't take this patch in and calgary will be broken with new
>   kexec-tools. And that will always require manual user intervention
>   from user to force passing memmap on command line.
> 
> I kind of prefer the first option so that even if there are some calgary
> machines out there, they will work automatically with new kernel and
> will require manual intervention only for old kernels and new kexec-tool
> cobination.
> 
> But I can live with second option too if that's everybody agrees to and
> hopefully we don't get lots of reports of breaking kdump with kexec-tools
> upgrade.
> 

The patch seems simple enough and doesn't require any new command line
hacks.  It has been widely reviewed and acked, so I'll pick it up.

	-hpa


