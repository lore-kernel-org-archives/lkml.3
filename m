Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946866Ab3BHRt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:49:27 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57712 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946809Ab3BHRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:49:26 -0500
Date: Fri, 8 Feb 2013 12:49:22 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Vijay Kumar Mishra <vijay.kumar@st.com>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 1/3] SPEAr13xx_defconfig: Enable Memory split 2G/2G
 needed
In-Reply-To: <CAKohpokPhHtuDDBPUYp9YPOrEnaaKxthjiAemq74qfour_3aYQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302081243400.6300@xanadu.home>
References: <cover.1360317993.git.vijay.kumar@st.com> <6cebd9755011670ecaeec7930b3fa7ed0f16b3b6.1360317993.git.vijay.kumar@st.com> <CAKohpokPhHtuDDBPUYp9YPOrEnaaKxthjiAemq74qfour_3aYQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Viresh Kumar wrote:

> Hi Vijay,
> 
> By mistake you have added an ST internal list in cc, fixed it now.
> 
> Subject should be:
> 
> ARM: SPEAr13xx: Enable 2G/2G Memory split in defconfig
> 
> On 8 February 2013 16:16, Vijay Kumar Mishra <vijay.kumar@st.com> wrote:
> > Memory split 2G/2G is enabled as needed for SPEAr1310 RevC board to boot.
> > Before enabling this option the boot was hanging at uncompressing linux.

I disagree.  The subject could have been "put our head in the sand and 
paper over bugs".

Please don't do that.  There is no reason for any machine not to boot 
way past "Uncompressing Linux" with the default split.  The likely 
reason it works with the 2G:2G split is because in that case the virtual 
and physical RAM addresses in the kernel are the same, and therefore 
missing p2v or v2p conversions are invisible.


Nicolas
