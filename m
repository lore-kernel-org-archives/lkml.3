Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaBZR5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:57:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43696 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaBZR5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:57:52 -0500
Message-ID: <530E2B06.5010608@zytor.com>
Date: Wed, 26 Feb 2014 09:57:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Chris Bainbridge <chris.bainbridge@gmail.com>, davej@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140225060146.GA4339@debian.local> <530C7465.2080600@zytor.com> <20140225162611.GA31902@redhat.com> <530CCFD2.3050007@zytor.com> <20140226121256.GA8494@debian.local> <20140226164433.GA19341@srcf.ucam.org> <530E1A35.40506@zytor.com> <20140226171053.GA22567@srcf.ucam.org>
In-Reply-To: <20140226171053.GA22567@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 09:10 AM, Matthew Garrett wrote:
> On Wed, Feb 26, 2014 at 08:45:41AM -0800, H. Peter Anvin wrote:
> 
>> Yes.  Grub can be made to behave sanely by using "linux16" and
>> "initrd16", but of course none of the distros do it that way.
> 
> Fedora does as of F20, but yeah, point taken.
> 

Oh, good to hear.

	-hpa

