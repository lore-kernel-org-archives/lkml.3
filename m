Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaGLNCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 09:02:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41902 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbaGLNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 09:02:45 -0400
Message-ID: <53C131EA.2020502@hurleysoftware.com>
Date: Sat, 12 Jul 2014 09:02:34 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty.current tree
References: <20140711112108.7631911b@canb.auug.org.au>	<53BFFD90.5010405@hurleysoftware.com> <20140712112012.69befaf0@canb.auug.org.au>
In-Reply-To: <20140712112012.69befaf0@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 09:20 PM, Stephen Rothwell wrote:
> Hi Peter,
>
> On Fri, 11 Jul 2014 11:06:56 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:
>>
>> Sorry about that. I don't have a full cross-compiler setup for
>> build testing. Looks like that's something I'm going to have to add.
>
> see https://www.kernel.org/pub/tools/crosstool/
>
> These are only good for building the kernel (no libc).
>
> You don't necessarily need to build the whole kernel but often just
> building the particular drivers is enough.  Especially if they are
> directly modified ...

Hi Stephen,

Thanks for the link. I had found Shuah Khan's slideshow pdf on cross-compiler
packages earlier and so have already started down that path.

Regards,
Peter Hurley
