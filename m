Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3FTOY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:24:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53514 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab3FTOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:24:55 -0400
Date: Thu, 20 Jun 2013 09:23:28 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv13 3/4] zswap: add to mm/
Message-ID: <20130620142328.GA9461@cerebellum>
References: <1370291585-26102-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1370291585-26102-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <CAA_GA1eWFYDxp3gEdWzajVP4jMpmJbt=oWBZYqZEQjndU=s_Qg@mail.gmail.com>
 <20130620023750.GA1194@cerebellum>
 <CAA_GA1c8cH1fu9jHk8evKZvK-gpQ+c8NEp5=_jDLKPcMbG_ufA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1c8cH1fu9jHk8evKZvK-gpQ+c8NEp5=_jDLKPcMbG_ufA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062014-7182-0000-0000-0000076F4127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 05:42:04PM +0800, Bob Liu wrote:
> > Just made a mmtests run of my own and got very different results:
> >
> 
> It's strange, I'll update to rc6 and try again.
> By the way, are you using 824 hardware compressor instead of lzo?

My results where using lzo software compression.

Seth

