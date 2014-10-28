Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaJ1AeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:34:11 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14227 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbaJ1AeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:34:08 -0400
Date: Mon, 27 Oct 2014 17:34:26 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Jeffrey Hugo <jhugo@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [RFC 4/7] soc: qcom: Add Shared Memory Manager driver
Message-ID: <20141028003424.GP28611@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-5-git-send-email-bjorn.andersson@sonymobile.com>
 <5435AD8E.2000109@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5435AD8E.2000109@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08 Oct 14:33 PDT 2014, Jeffrey Hugo wrote:

[..]
> > + */
> > +struct smem_header {
> > +     struct smem_proc_comm proc_comm[4];
> > +     u32 version[32];
> > +     u32 smem_initialized;
> > +     u32 free_offset;
> > +     u32 available;
> > +     u32 unused;
> 
> I see that you inlined the smem_heap_info struct.  That is slightly
> problematic since we have some uses of that structure, and without it,
> accessing id 1 becomes complicated.  I would prefer you reintroduce it.
> 

Could you help me better understand what you mean here? I've scanned through
msm-3.4 and msm-3.10 and read your comment numerous times, but I can't find any
uses that needs it nor figure out why it would be difficult to access item 1.

> > +     struct smem_entry toc[SMEM_MAX_ITEMS];
> > +};

Thanks,
Bjorn
