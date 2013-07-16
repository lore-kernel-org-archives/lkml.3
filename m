Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3GPVPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:15:51 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:32945 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926Ab3GPVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:15:48 -0400
Message-ID: <51E5B7FF.9080004@mentor.com>
Date: Tue, 16 Jul 2013 22:15:43 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michal Marek <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] kbuild: Build samples directory with make modules
References: <jim_baxter@mentor.com> <1373999390-14548-1-git-send-email-jim_baxter@mentor.com> <20130716193714.GA19924@merkur.ravnborg.org>
In-Reply-To: <20130716193714.GA19924@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 16 Jul 2013 21:15:46.0080 (UTC) FILETIME=[A327E200:01CE8269]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/13 20:37, Sam Ravnborg wrote:
> On Tue, Jul 16, 2013 at 07:29:50PM +0100, Jim Baxter wrote:
>> If CONFIG_SAMPLES is enabled with any of the sample
>> modules enabled, they are only built if the make command
>> includes uImage and modules (i.e. make uImage modules).
> 
> With the current location samples are built when you build vmlinux.
> And vmlinux is implicit when you just type "make".
> 
> With the suggestion you have samples are built when you do "make modules".
> IMO this is less logical than to built them with vmlinux as we do today.
> 
> 	Sam
> 

Hi,

I am building it with:
make uImage
make modules

At least bitbake in Yocto and Openembedded is.

Running make on it's own is the equivalent of:
make vmlinux modules

which builds the samples directory, however if you run:
make vmlinux
make modules

Then the Samples are not built, that is what I am trying to fix.

Thank you,
Jim
