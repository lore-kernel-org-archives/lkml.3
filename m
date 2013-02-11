Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3BKDug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 22:50:36 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:35163 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715Ab3BKDuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 22:50:35 -0500
Date: Mon, 11 Feb 2013 09:20:14 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Vijay Kumar Mishra <vijay.kumar@st.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 1/3] SPEAr13xx_defconfig: Enable Memory split 2G/2G
 needed
Message-ID: <20130211035014.GA3303@localhost.localdomain>
References: <cover.1360317993.git.vijay.kumar@st.com>
 <6cebd9755011670ecaeec7930b3fa7ed0f16b3b6.1360317993.git.vijay.kumar@st.com>
 <CAKohpokPhHtuDDBPUYp9YPOrEnaaKxthjiAemq74qfour_3aYQ@mail.gmail.com>
 <alpine.LFD.2.02.1302081243400.6300@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302081243400.6300@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Fri, Feb 08, 2013 at 12:49:22PM -0500, Nicolas Pitre wrote:
> On Fri, 8 Feb 2013, Viresh Kumar wrote:
> > 
> > By mistake you have added an ST internal list in cc, fixed it now.
> > 
> > Subject should be:
> > 
> > ARM: SPEAr13xx: Enable 2G/2G Memory split in defconfig
> > 
> > On 8 February 2013 16:16, Vijay Kumar Mishra <vijay.kumar@st.com> wrote:
> > > Memory split 2G/2G is enabled as needed for SPEAr1310 RevC board to boot.
> > > Before enabling this option the boot was hanging at uncompressing linux.
> 
> I disagree.  The subject could have been "put our head in the sand and 
> paper over bugs".
> 
> Please don't do that.  There is no reason for any machine not to boot 
> way past "Uncompressing Linux" with the default split.  The likely 
> reason it works with the 2G:2G split is because in that case the virtual 
> and physical RAM addresses in the kernel are the same, and therefore 
> missing p2v or v2p conversions are invisible.

I agree. Actually the details are misleading. SPEAr13xx chose this
option just for its own preference over high memory support.

@Vijay,
I think you should drop this patch and just enable high memory support
rather, if SPEAr13xx doesn't have any problem with that.

--
regards
Shiraz
