Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbaKUGmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:42:42 -0500
Received: from 1wt.eu ([62.212.114.60]:57955 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaKUGml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:42:41 -0500
Date: Fri, 21 Nov 2014 07:42:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: Wang Zhe <wzedmund@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel support on Loognson 3B
Message-ID: <20141121064238.GB27040@1wt.eu>
References: <CAMYNMg5g+-PpgqmdVEbRqWRFj0NAUPXxmZfwsZDVYaMKOnfAAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMYNMg5g+-PpgqmdVEbRqWRFj0NAUPXxmZfwsZDVYaMKOnfAAQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 21, 2014 at 02:31:39PM +0800, Wang Zhe wrote:
> Hi,
> Currently I am working on Loongson 3B CPU with modified kernel version
> of linux 3.5.0. I encountered a problem when I boot up PC and it keeps
> entering into emergency mode. I' ve tried many different ways to get
> rid of this issue and nothing worked out. I wondered it could be an
> issue of using wrong kernel version. May I ask which official kernel
> verison has better support on loongson 3B CPU?

The stable list isn't about helping diagnose such issues. Also, you seem
to be using a vendor-specific kernel, so nobody working on the official
kernel will be able to help you. You need to contact your vendor to get
support on this. Maybe they'll indicate you that a recent mainline kernel
supports their CPU well, and even then it can depend on your board. Last
point, 3.5.0 is quite outdated and unsupported. It lacks many bugfixes
and important security fixes, so you should not run that anyway. Keep in
mind that many vendor-specific kernels don't include fixes from mainline
and based on that, you should always select your hardware based on its
support in mainline instead of chosing the kernel based on the hardware.

Regards,
Willy

