Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030906Ab3HITum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:50:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877Ab3HITul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:50:41 -0400
Date: Fri, 9 Aug 2013 12:50:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809195040.GA6950@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E61761C23@sisaex02sj>
 <20130809191002.GC10130@kroah.com>
 <B8EFE96D1287C24090BAD9D858E15E61762295@sisaex02sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61762295@sisaex02sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 07:45:51PM +0000, Shuah Khan wrote:
> On 08/09/2013 01:10 PM, Greg Kroah-Hartman wrote:
> > On Fri, Aug 09, 2013 at 02:42:24PM +0000, Shuah Khan wrote:
> >> On 08/09/2013 07:54 AM, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 3.10.6 release.
> >>> There are 102 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>>
> >>
> >> I don't see the new stable release patches on
> >>
> >> www.kernel.org/pub/linux/kernel/v3.0/stable-review/
> >>
> >> Others were able to download last night as I can see from the test
> >> responses. Something must have happened. Tried accessing with ftp client
> >> as well.
> >
> > No, the patches never made it there, I think people were testing based
> > on the git tree.
> >
> > kernel.org is now fixed, and the patches should be there within a few
> > minutes.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Greg,
> 
> Noticed the following when I applied 3.10.6-rc1
> 
> git apply --index < ../stable_tree_project/patch-3.10.6-rc1
> <stdin>:1369: space before tab in indent.
>   	 * Revision 13 of all triggering devices id in this quirk have
> warning: 1 line adds whitespace errors.

Known issue, the original patch causes that same warning, nothing I can
do about it :(

thanks,

greg k-h
